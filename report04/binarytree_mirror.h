#ifndef INCLUDE_GUARD_BINARYTREE_MIRROR_H
#define INCLUDE_GUARD_BINARYTREE_MIRROR_H

#include "binarytree.h"
#include <stdbool.h>

Node *create_mirror(Node *n);
bool are_mirrors(Node *n0, Node *n1);

#endif // INCLUDE_GUARD_BINARYTREE_MIRROR_H
