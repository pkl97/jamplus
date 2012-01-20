function Test()
	local originalFiles =
	{
		'Jamfile.jam',
		'test.lua',
		'app/Jamfile.jam',
		'app/main.c',
		'lib-c/Jamfile.jam',
		'lib-c/add.c',
		'lib-c/add.h',
		'slib-a/Jamfile.jam',
		'slib-a/slib-a.c',
		'slib-b/Jamfile.jam',
		'slib-b/slib-b.c',
	}

	local originalDirs =
	{
		'app/',
		'lib-c/',
		'slib-a/',
		'slib-b/',
	}

	do
		-- Test for a clean directory.
		RunJam{ 'clean' }
		TestDirectories(originalDirs)
		TestFiles(originalFiles)
	end

	---------------------------------------------------------------------------
	local dirs =
	{
		'app/',
		'image/',
		'lib-c/',
		'slib-a/',
		'slib-b/',
		'image/TOP/',
		'image/TOP/app/',
		'image/TOP/lib-c/',
		'image/TOP/slib-a/',
		'image/TOP/slib-b/',
		'image/TOP/app/win32!release/',
		'image/TOP/app/win32!release/app/',
		'image/TOP/lib-c/win32!release/',
		'image/TOP/lib-c/win32!release/lib-c/',
		'image/TOP/slib-a/win32!release/',
		'image/TOP/slib-a/win32!release/slib-a/',
		'image/TOP/slib-b/win32!release/',
		'image/TOP/slib-b/win32!release/slib-b/',
	}
	
	local files
	
	if Platform == 'win32' then
		files = {
			'Jamfile.jam',
			'test.lua',
			'app/Jamfile.jam',
			'app/main.c',
			'image/app.release.exe',
			'image/app.release.pdb',
			'image/slib-a.release.dll',
			'image/slib-a.release.exp',
			'image/slib-a.release.lib',
			'image/slib-a.release.pdb',
			'image/slib-b.release.dll',
			'image/slib-b.release.exp',
			'image/slib-b.release.lib',
			'image/slib-b.release.pdb',
			'image/TOP/app/win32!release/app/app.release.exe.intermediate.manifest',
			'image/TOP/app/win32!release/app/main.obj',
			'image/TOP/lib-c/win32!release/lib-c/add.obj',
			'image/TOP/lib-c/win32!release/lib-c/lib-c.release.lib',
			'image/TOP/slib-a/win32!release/slib-a/slib-a.obj',
			'image/TOP/slib-a/win32!release/slib-a/slib-a.release.dll.intermediate.manifest',
			'image/TOP/slib-b/win32!release/slib-b/slib-b.obj',
			'image/TOP/slib-b/win32!release/slib-b/slib-b.release.dll.intermediate.manifest',
			'lib-c/add.c',
			'lib-c/add.h',
			'lib-c/Jamfile.jam',
			'slib-a/Jamfile.jam',
			'slib-a/slib-a.c',
			'slib-b/Jamfile.jam',
			'slib-b/slib-b.c',
		}
	else
	
		files = {
			'Jamfile.jam',
			'app/Jamfile.jam',
			'app/main.c',
			'app/image/app.release',
			'image/slib-a.release.so',
			'image/slib-b.release.so',
			'image/TOP/app/main.o',
			'image/TOP/lib-c/add.o',
			'image/TOP/lib-c/lib-c.release.a',
			'image/TOP/slib-a/slib-a.o',
			'image/TOP/slib-b/slib-b.o',
			'lib-c/add.c',
			'lib-c/add.h',
			'lib-c/Jamfile.jam',
			'slib-a/Jamfile.jam',
			'slib-a/slib-a.c',
			'slib-b/Jamfile.jam',
			'slib-b/slib-b.c',
		}
	end

	local pattern
	do
		if Platform == 'win32' then
		 	pattern = [[
*** found 48 target(s)...
*** updating 24 target(s)...
@ C.vc.CC <win32!release:app>main.obj
!NEXT!@ C.vc.CC <win32!release:slib-a>slib-a.obj
!NEXT!@ C.vc.CC <win32!release:lib-c>add.obj
@ C.vc.Archive <win32!release:lib-c>lib-c.lib
@ C.vc.LinkWithManifest <win32!release:slib-a>slib-a.dll
!NEXT!@ C.vc.CC <win32!release:slib-b>slib-b.obj
!NEXT!@ C.vc.LinkWithManifest <win32!release:slib-b>slib-b.dll
!NEXT!@ C.vc.LinkWithManifest <win32!release:app>app.exe
*** updated 24 target(s)...
]]
		else
			pattern = [[
				*** found 29 target(s)...
				*** updating 16 target(s)...
				@ C.CC <lib-c>add.o 
				@ C.Archive <lib-c>lib-c.a 
				!NEXT!@ C.Ranlib <lib-c>lib-c.a 
				@ C.CC <slib-a>slib-a.o 
				@ C.Link <slib-a>slib-a.release.so 
				@ C.CC <slib-b>slib-b.o 
				@ C.Link <slib-b>slib-b.release.so 
				@ C.CC <app>main.o 
				@ C.Link <app>app.release 
				*** updated 16 target(s)...
]]
		end

		TestPattern(pattern, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		if Platform == 'win32' then
			pattern = [[
*** found 48 target(s)...
]]
		else
			pattern = [[
				*** found 29 target(s)...
]]
		end
		TestPattern(pattern, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		os.sleep(1.0)
		os.touch('lib-c/add.h')

		if Platform == 'win32' then
			pattern = [[
*** found 48 target(s)...
*** updating 4 target(s)...
@ C.vc.CC <win32!release:slib-a>slib-a.obj
!NEXT!@ C.vc.LinkWithManifest <win32!release:slib-a>slib-a.dll
!NEXT!@ C.vc.CC <win32!release:slib-b>slib-b.obj
!NEXT!@ C.vc.LinkWithManifest <win32!release:slib-b>slib-b.dll
!NEXT!*** updated 4 target(s)...
]]
		else
			pattern = [[
				*** found 29 target(s)...
				*** updating 7 target(s)...
				@ C.CC <slib-a>slib-a.o 
				@ C.Link <slib-a>slib-a.release.so 
				@ C.CC <slib-b>slib-b.o 
				@ C.Link <slib-b>slib-b.release.so 
				@ C.Link <app>app.release 
				*** updated 7 target(s)...
]]
		end
		TestPattern(pattern, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		if Platform == 'win32' then
			pattern = [[
*** found 48 target(s)...
]]
		else
			pattern = [[
				*** found 29 target(s)...
]]
		end
		TestPattern(pattern, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		os.sleep(1.0)
		os.touch('lib-c/add.c')

		if Platform == 'win32' then
			pattern = [[
@ C.vc.CC <win32!release:lib-c>add.obj
!NEXT!@ C.vc.Archive <win32!release:lib-c>lib-c.lib
!NEXT!@ C.vc.LinkWithManifest <win32!release:slib-a>slib-a.dll
!NEXT!@ C.vc.LinkWithManifest <win32!release:slib-b>slib-b.dll
!NEXT!*** updated 4 target(s)...
]]
		else
			pattern = [[
				*** found 29 target(s)...
				*** updating 7 target(s)...
				@ C.CC <lib-c>add.o 
				@ C.Archive <lib-c>lib-c.a 
				@ C.Ranlib <lib-c>lib-c.a 
				@ C.Link <slib-a>slib-a.release.so 
				@ C.Link <slib-b>slib-b.release.so 
				@ C.Link <app>app.release 
				*** updated 7 target(s)...
]]
		end
		TestPattern(pattern, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		if Platform == 'win32' then
			pattern = [[
*** found 48 target(s)...
]]
		else
			pattern = [[
				*** found 29 target(s)...
]]
		end
		TestPattern(pattern, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		os.sleep(1.0)
		os.touch('slib-a/slib-a.c')

		if Platform == 'win32' then
			pattern = [[
*** found 48 target(s)...
*** updating 3 target(s)...
@ C.vc.CC <win32!release:slib-a>slib-a.obj
!NEXT!@ C.vc.LinkWithManifest <win32!release:slib-a>slib-a.dll
!NEXT!*** updated 2 target(s)...
]]
		else
			pattern = [[
				*** found 29 target(s)...
				*** updating 4 target(s)...
				@ C.CC <slib-a>slib-a.o 
				@ C.Link <slib-a>slib-a.release.so 
				@ C.Link <app>app.release 
				*** updated 4 target(s)...
]]
		end
		TestPattern(pattern, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	do
		if Platform == 'win32' then
			pattern = [[
*** found 48 target(s)...
]]
		else
			pattern = [[
				*** found 29 target(s)...
]]
		end
		TestPattern(pattern, RunJam{})
		TestDirectories(dirs)
		TestFiles(files)
	end

	---------------------------------------------------------------------------
	RunJam{ 'clean' }
	TestFiles(originalFiles)
	TestDirectories(originalDirs)
end
