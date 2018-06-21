/**
 * Original edge relation
 */
predicate e1(int x, int y) {
  x=1 and y=2
  or
  x=2 and y=3
  or
  x=3 and y=4
  or
  x=5 and y=6
}

/**
 * Original TC
 */
predicate fullTc1(int x, int y) {
  e1+(x, y)
}

/**
 * Up change to the edge relation
 */
predicate eUpdiff(int x, int y) {
  x=4 and y=5
}

/**
 * Down change to the edge relation
 */
predicate eDowndiff(int x, int y) {
  x=2 and y=3
}

/**
 * Updated edge relation
 */
predicate e2(int x, int y) {
  (e1(x,y) or eUpdiff(x,y)) and not eDowndiff(x, y)
}

/**
 * TC with the current changes applied
 */
query predicate fullTc1Changed(int x, int y) {
  (fullTc1(x,y) or currentUpdiff(x,y)) and not currentDowndiff(x, y)
}

// df(fix(f))
query predicate firstComponentUpdiff(int x, int y) {
  (e2(x,y) or exists(int z | e2(x,z) and fullTc1(z,y)))
  and
  not (e1(x,y) or exists(int z | e1(x,z) and fullTc1(z,y)))
}

query predicate firstComponentDowndiff(int x, int y) {
  (e1(x,y) or exists(int z | e1(x,z) and fullTc1(z,y)))
  and
  not (e2(x,y) or exists(int z | e2(x,z) and fullTc1(z,y)))
}

// (f+df)'(fix(f), da)
query predicate secondComponentUpdiff(int x, int y) {
  exists(int z | e2(x,z) and currentUpdiff(z, y))
}

query predicate secondComponentDowndiff(int x, int y) {
  not e2(x, y)
  and
  exists(int z | e2(x,z) and currentDowndiff(z, y))
  and
  not exists(int z | e2(x,z) and fullTc1Changed(z,y))
}

query predicate combinedUpdiff(int x, int y) {
  (firstComponentUpdiff(x, y) and not firstComponentDowndiff(x,y)) or secondComponentUpdiff(x,y)
}

query predicate combinedDowndiff(int x, int y) {
  (firstComponentDowndiff(x, y) and not secondComponentUpdiff(x,y))or secondComponentDowndiff(x,y)
}

/**
 * The currrent up diff. Update to be `combinedUpdiff` from the previous run and iterate.
 */
predicate currentUpdiff(int x, int y) {
	none()
}

/**
 * The currrent down diff. Update to be `combinedDowndiff` from the previous run and iterate.
 */
predicate currentDowndiff(int x, int y) {
	none()
}