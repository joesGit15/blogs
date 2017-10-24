### How to get length of file in C

```
//===
int fileLen(FILE *fp)
{
    int nRet = -1;
    int nPosBak;

    nPosBak = ftell(fp);///< current position in file

    fseek(fp, 0, SEEK_END);
    nRet = ftell(fp);

    fseek(fp, nPosBak, SEEK_SET);///< write back position to file
    return nRet;
}
```

---
