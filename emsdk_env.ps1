# emsdk_env.batとだいたい同じ動きをさせる
. (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "emsdk.ps1") construct_env $args

