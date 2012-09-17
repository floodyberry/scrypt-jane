#!/bin/sh

test() {
	rm -f scrypt_test
	gcc scrypt-jane-test.c -O3 -DSCRYPT_$1 -DSCRYPT_$2 $3 -o scrypt_test 2>/dev/null
	local RC=$?
	if [ $RC -ne 0 ]; then
		echo "$1/$2: failed to compile "
		return
	fi
	./scrypt_test >/dev/null
	local RC=$?
	rm -f scrypt_test
	if [ $RC -ne 0 ]; then
		echo "$1/$2: validation failed"
		return
	fi
	echo "$1/$2: OK"
}

testhash() {
	test $1 SALSA $2
	test $1 CHACHA $2
}

testhashes() {
	testhash SHA256 $1
	testhash SHA512 $1
	testhash BLAKE256 $1
	testhash BLAKE512 $1
	testhash SKEIN512 $1
}

if [ -z $1 ]; then
	testhashes
elif [ $1 -eq 32 ]; then
	testhashes -m32
elif [ $1 -eq 64 ]; then
	testhashes -m64
fi

