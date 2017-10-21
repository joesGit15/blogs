## Overview of Qt's Undo Framework

### Introduction

Qt's Undo Framework is an implementation of the Command pattern, for implementing undo/redo functionality in applications.

The Command pattern is based on the idea that all editing in an application is done by creating instances of command objects. Command objects apply changes to the document and are stored on a command stack. Furthermore(此外), each command knows how to undo its changes to bring the document back to its previous state. As long as the application only uses command objects to change the state of the document, it is possible to undo a sequence of commands by traversing the stack downwards and calling undo on each command in turn. It is also possible to redo a sequence of commands by traversing the stack upwards and calling redo on each command.

### Classes

The framework consists of four classes:

1. QUndoCommand is the base class of all commands stored on an undo stack. It can apply (redo) or undo a single change in the document.
2. QUndoStack is a list of QUndoCommand objects. It contains all the commands executed on the document and can roll the document's state backwards or forwards by undoing or redoing them.
3. QUndoGroup is a group of undo stacks. It is useful when an application contains more than one undo stack, typically one for each opened document. QUndoGroup provides a single pair of undo/redo slots for all the stacks in the group. It forwards undo and redo requests to the active stack, which is the stack associated with the document that is currently being edited by the user.
4. QUndoView is a widget which shows the contents of an undo stack. Clicking on a command in the view rolls the document's state backwards or forwards to that command.

### Concepts

The following concepts are supported by the framework:

- Clean state: Used to signal when the document enters and leaves a state that has been saved to disk. This is typically used to disable or enable the save actions, and to update the document's title bar.
- Command compression: Used to compress sequences of commands into a single command. For example: In a text editor, the commands that insert individual characters into the document can be compressed into a single command that inserts whole sections of text. These bigger changes are more convenient for the user to undo and redo.
- Command macros: A sequence of commands, all of which are undone or redone in one step. These simplify the task of writing an application, since a set of simpler commands can be composed into more complex commands. For example, a command that moves a set of selected objects in a document can be created by combining a set of commands, each of which moves a single object.

QUndoStack provides convenient undo and redo QAction objects that can be inserted into a menu or a toolbar. The text properties of these actions always reflect what command will be undone or redone when they are triggered. Similarly, QUndoGroup provides undo and redo actions that always behave like the undo and redo actions of the active stack.

### QUndoCommand

The QUndoCommand class is the base class of all commands stored on a QUndoStack.

A QUndoCommand represents a single editing action on a document; for example, inserting or deleting a block of text in a text editor. QUndoCommand can apply a change to the document with redo() and undo the change with undo(). The implementations for these functions must be provided in a derived class.

```cpp
class AppendText : public QUndoCommand
{
public:
    AppendText(QString *doc, const QString &text)
        : m_document(doc), m_text(text) { setText("append text"); }
    virtual void undo()
        { m_document->chop(m_text.length()); }
    virtual void redo()
        { m_document->append(m_text); }
private:
    QString *m_document;
    QString m_text;
};
```

A QUndoCommand has an associated text(). This is a short string describing what the command does. It is used to update the text properties of the stack's undo and redo actions; see `QUndoStack::createUndoAction()` and `QUndoStack::createRedoAction()`.

QUndoCommand objects are owned by the stack they were pushed on. **QUndoStack deletes a command if it has been undone and a new command is pushed**. For example:

```cpp
MyCommand *command1 = new MyCommand();
stack->push(command1);
MyCommand *command2 = new MyCommand();
stack->push(command2);

stack->undo();

MyCommand *command3 = new MyCommand();
stack->push(command3); // command2 gets deleted
```

In effect, when a command is pushed, it becomes the top-most command on the stack.

To support command compression, QUndoCommand has an `id()` and the virtual function `mergeWith()`. These functions are used by `QUndoStack::push()`.

To support command macros, **a QUndoCommand object can have any number of child commands. Undoing or redoing the parent command will cause the child commands to be undone or redone. A command can be assigned to a parent explicitly in the constructor. In this case, the command will be owned by the parent**.

**The parent in this case is usually an empty command, in that it doesn't provide its own implementation of undo() and redo(). Instead, it uses the base implementations of these functions, which simply call undo() or redo() on all its children.** The parent should, however, have a meaningful text().

```cpp
QUndoCommand *insertRed = new QUndoCommand(); // an empty command
insertRed->setText("insert red text");

new InsertText(document, idx, text, insertRed); // becomes child of insertRed
new SetColor(document, idx, text.length(), Qt::red, insertRed);

stack.push(insertRed);
```

Another way to create macros is to use the convenience functions `QUndoStack::beginMacro()` and `QUndoStack::endMacro()`.

### QUndoStack

The QUndoStack class is a stack of QUndoCommand objects.

An undo stack maintains a stack of commands that have been applied to a document.

New commands are pushed on the stack using `push()`. Commands can be undone and redone using `undo()` and `redo()`, or by triggering the actions returned by `createUndoAction()` and `createRedoAction()`.

QUndoStack keeps track of the current command. This is the command which will be executed by the next call to redo(). The index of this command is returned by `index()`. The state of the edited object can be rolled forward or back using `setIndex()`. If the top-most command on the stack has already been redone, index() is equal to `count()`.

QUndoStack provides support for undo and redo actions, command compression, command macros, and supports the concept of a clean state.

#### Undo and Redo Actions

QUndoStack provides convenient undo and redo QAction objects, which can be inserted into a menu or a toolbar. When commands are undone or redone, QUndoStack updates the text properties of these actions to reflect what change they will trigger. The actions are also disabled when no command is available for undo or redo. These actions are returned by QUndoStack::createUndoAction() and QUndoStack::createRedoAction().

#### Clean State

QUndoStack supports the concept of a clean state. When the document is saved to disk, the stack can be marked as clean using `setClean()`. Whenever the stack returns to this state through undoing and redoing commands, it emits the signal `cleanChanged()`. This signal is also emitted when the stack leaves the clean state. This signal is usually used to enable and disable the save actions in the application, and to update the document's title to reflect that it contains unsaved changes.

#### Obsolete Commands

QUndoStack is able to delete commands from the stack if the command is no longer needed. One example may be to delete a command when two commands are merged together in such a way that the merged command has no function. This can be seen with move commands where the user moves their mouse to one part of the screen and then moves it to the original position. The merged command results in a mouse movement of 0. This command can be deleted since it serves no purpose. Another example is with networking commands that fail due to connection issues. In this case, the command is to be removed from the stack because the redo() and undo() functions have no function since there was connection issues.

A command can be marked obsolete(过时的) with the `QUndoCommand::setObsolete()` function. The `QUndoCommand::isObsolete()` flag is checked in QUndoStack::push(), QUndoStack::undo(), QUndoStack::redo(), and QUndoStack::setIndex() after calling QUndoCommand::undo(), QUndoCommand::redo() and QUndoCommand:mergeWith() where applicable.

If a command is set obsolete and the clean index is greater than or equal to the current command index, then the clean index will be reset when the command is deleted from the stack.

### QUndoGroup

The QUndoGroup class is a group of QUndoStack objects.

An application often has multiple undo stacks, one for each opened document. At the same time, an application usually has one undo action and one redo action, which triggers undo or redo in the active document.

QUndoGroup is a group of QUndoStack objects, one of which may be active. **It has an undo() and redo() slot, which calls QUndoStack::undo() and QUndoStack::redo() for the active stack**. It also has the functions createUndoAction() and createRedoAction(). The actions returned by these functions behave in the same way as those returned by QUndoStack::createUndoAction() and QUndoStack::createRedoAction() of the active stack.

Stacks are added to a group with `addStack()` and removed with `removeStack()`. A stack is implicitly added to a group when it is created with the group as its parent QObject.

It is the programmer's responsibility to specify which stack is active by calling `QUndoStack::setActive()`, usually when the associated document window receives focus. The active stack may also be set with `setActiveStack()`, and is returned by `activeStack()`.

When a stack is added to a group using addStack(), **the group does not take ownership of the stack. This means the stack has to be deleted separately from the group. When a stack is deleted, it is automatically removed from a group. A stack may belong to only one group. Adding it to another group will cause it to be removed from the previous group.**

A QUndoGroup is also useful in conjunction with QUndoView. If a QUndoView is set to watch a group using `QUndoView::setGroup()`, it will update itself to display the active stack.

### QUndoView`

The QUndoView class displays the contents of a QUndoStack.

QUndoView is a QListView which displays the list of commands pushed on an undo stack. The most recently executed command is always selected. Selecting a different command results in a call to QUndoStack::setIndex(), rolling the state of the document backwards or forward to the new command.

The stack can be set explicitly with setStack(). Alternatively, a QUndoGroup object can be set with setGroup(). The view will then update itself automatically whenever the active stack of the group changes.

### Demos

1. [undoframework](https://github.com/joesGit15/com.qt.io.demo/tree/master/widget/undoframework/src)
2. [undo](https://github.com/joesGit15/com.qt.io.demo/tree/master/widget/undo/src)

### Reference

> Qt Help manual


---

