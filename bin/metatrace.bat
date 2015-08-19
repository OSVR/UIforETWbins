@rem Copyright 2015 Google Inc. All Rights Reserved.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.

@rem Use this batch file to profile the ETW profiler. If the save or merge
@rem steps of UIforETW or wprui are very slow then this batch file can profile
@rem them. Save this batch file for special occasions. This works by using
@rem "Circular Kernel Context Logger" instead of  "NT Kernel Logger",
@rem which makes it possible to have two kernel loggers running simultaneously.

@echo Preparing to profile the ETW profiler.

@setlocal
@set tempFile=%temp%\kernel_meta.etl
@set kernel=-start "Circular Kernel Context Logger"
@set kernel=%kernel% -on Latency+POWER+DISPATCHER+FILE_IO+FILE_IO_INIT
@set kernel=%kernel% -stackwalk PROFILE+CSWITCH+READYTHREAD
@set kernel=%kernel% -minbuffers 300 -maxbuffers 300 -buffersize 1024
@set kernel=%kernel% -f "%tempFile%"
xperf %kernel%
@echo Hit enter when enough data has been recorded.
@pause
xperf -stop "Circular Kernel Context Logger"

@rem Rename c:\Windows\AppCompat\Programs\amcache.hve to avoid serious merge
@rem performance problems (up to six minutes!)
@set HVEDir=c:\Windows\AppCompat\Programs
@rename %HVEDir%\Amcache.hve Amcache_temp.hve 2>nul
@set RenameErrorCode=%errorlevel%

xperf -merge "%tempFile%" "%temp%\metatrace.etl" -compress
@del "%tempFile%"

@rem Rename the file back
@if not "%RenameErrorCode%" equ "0" goto SkipRename
@rename %HVEDir%\Amcache_temp.hve Amcache.hve
:SkipRename
