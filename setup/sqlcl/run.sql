-- Wrapper used by `lab run FILE`: runs the file and exits.
whenever sqlerror continue
@"&1"
exit
