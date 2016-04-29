#ifndef __TYPES_H__
#define __TYPES_H__

#define True	1
#define False	0
#define	null	0

#pragma pack(push, 1)

typedef struct vmem_char {
	unsigned char ch;
	unsigned char attr;
} vmem;

#pragma pack(pop)

#endif
