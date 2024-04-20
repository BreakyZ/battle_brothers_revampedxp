foreach (file in ::IO.enumerateFiles("revampedxp_hooks/hooks"))
{
	::include(file);
}