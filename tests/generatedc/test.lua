function Test()
	-- Test for a clean directory.
	local originalFiles =
	{
		'Jamfile.jam',
		'file.txt',
		'main.c',
	}

	local originalDirs =
	{
	}

	RunJam{ 'clean' }
	TestDirectories(originalDirs)
	TestFiles(originalFiles)

	if Platform == 'win32' then
		-- First build
		local pattern = [[
*** found 18 target(s)...
*** updating 6 target(s)...
@ GenerateCFile <win32!release:helloworld>file.c
!NEXT!@ C.vc.CC <win32!release:helloworld>main.obj
!NEXT!@ C.vc.LinkWithManifest <win32!release:helloworld>helloworld.exe
!NEXT!*** updated 6 target(s)...
]]

		TestPattern(pattern, RunJam())

		local pass1Dirs = {
			'win32!release/',
			'win32!release/helloworld/',
		}

		local pass1Files = {
			'file.c',
			'file.txt',
			'Jamfile.jam',
			'main.c',
			'test.lua',
			'win32!release/helloworld/file.obj',
			'win32!release/helloworld/helloworld.release.exe',
			'win32!release/helloworld/helloworld.release.exe.intermediate.manifest',
			'win32!release/helloworld/helloworld.release.pdb',
			'win32!release/helloworld/main.obj',
		}

		TestFiles(pass1Files)
		TestDirectories(pass1Dirs)

		local pattern2 = [[
*** found 18 target(s)...
]]
		TestPattern(pattern2, RunJam())

		os.sleep(1.0)
		os.touch('file.c')

		local pattern3 = [[
*** found 18 target(s)...
*** updating 2 target(s)...
@ C.vc.CC <win32!release:helloworld>file.obj
file.c
!NEXT!@ C.vc.LinkWithManifest <win32!release:helloworld>helloworld.exe
!NEXT!*** updated 2 target(s)...
]]
		TestPattern(pattern3, RunJam())
		TestFiles(pass1Files)
		TestDirectories(pass1Dirs)

	else
        error("Not created on non-Windows platforms yet")
		-- First build
		local pattern = [[
*** found 9 target(s)...
*** updating 3 target(s)...
@ C.CC <helloworld>main.o
@ C.CC <helloworld>file.o
@ C.Link <helloworld>helloworld.release
*** updated 3 target(s)...
]]

		TestPattern(pattern, RunJam())

		local pass1Files =
		{
			'Jamfile.jam',
			'file.c',
			'file.o',
			'helloworld.release',
			'main.c',
			'main.o',
		}

		TestFiles(pass1Files)
		TestDirectories(originalDirs)

		local pattern2 = [[
*** found 9 target(s)...
]]
		TestPattern(pattern2, RunJam())

		os.sleep(1.0)
		os.touch('file.c')

		local pattern3 = [[
*** found 9 target(s)...
*** updating 2 target(s)...
@ C.CC <helloworld>file.o
@ C.Link <helloworld>helloworld.release
*** updated 2 target(s)...
]]
		TestPattern(pattern3, RunJam())
		TestFiles(pass1Files)
		TestDirectories(originalDirs)
	end

	RunJam{ 'clean' }

	TestDirectories(originalDirs)
	TestFiles(originalFiles)
end

