keylog: keylog.asm file_make.asm encrypt_and_put.asm
	nasm -f win64 keylog.asm -o keylog.obj
	nasm -f win64 file_make.asm -o file_make.obj
	nasm -f win64 encrypt_and_put.asm -o encrypt_and_put.obj
	gcc keylog.obj file_make.obj encrypt_and_put.obj -o keylog.exe -lkernel32 -luser32 -lmsvcrt

clean:
	rm -f *.obj keylog.exe
	rm -f *.obj dec.exe

dec: decrypt.asm encrypt_and_put.asm
	nasm -f win64 decrypt.asm -o decrypt.obj
	nasm -f win64 encrypt_and_put.asm -o encrypt_and_put.obj
	gcc decrypt.obj encrypt_and_put.obj -o dec.exe 
