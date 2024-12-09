#ifdef CLIPBOARD_IMPLS_DECLARE
# define IMPL_DEFINE(subsystem, factory) std::shared_ptr<ClipboardImpl> factory();
#endif
#ifdef CLIPBOARD_IMPLS_DEFINE
# define IMPL_DEFINE(subsystem, factory) { subsystem, factory },
#endif

IMPL_DEFINE(SDL_SYSWM_X11, ExternalClipboardFactory)
IMPL_DEFINE(SDL_SYSWM_WAYLAND, ExternalClipboardFactory)

#undef IMPL_DEFINE
