import os

config_path = os.environ['HOME'] + '/.config/qutebrowser/'

config.load_autoconfig(False)

config.set(
    'content.blocking.hosts.lists',
    [
        'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts',
    ]
)
config.set(
    'content.blocking.adblock.lists',
    [
        "https://easylist.to/easylist/easylist.txt",
        "https://easylist.to/easylist/easyprivacy.txt",
        "https://easylist-downloads.adblockplus.org/antiadblockfilters.txt",
        "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
        "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
        "https://secure.fanboy.co.nz/r/fanboy-ultimate.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
        config_path + 'adblock_filters.txt',
    ]
)

# Start pages and search engines
default_search = 'https://opnxng.com/'
config.set('url.default_page', default_search)
config.set('url.start_pages', default_search)

search_engines = {
    'DEFAULT': default_search + '?q={}'
}
config.set('url.searchengines', search_engines)

# Theming
config.set('colors.webpage.preferred_color_scheme', 'dark')
config.set('colors.webpage.darkmode.algorithm', 'lightness-cielab')
config.set('colors.webpage.darkmode.contrast', 0.0)
config.set('colors.webpage.darkmode.enabled', False)
config.set('colors.webpage.darkmode.policy.images', 'smart')
config.set('colors.webpage.darkmode.policy.page', 'smart')
config.set('colors.webpage.darkmode.threshold.background', 0)
config.set('colors.webpage.darkmode.threshold.foreground', 256)

# Use MPV for videos
config.bind(',m', 'spawn mpv {url}')
config.bind(',M', 'hint links spawn mpv {hint-url}')
config.bind(';M', 'hint --rapid links spawn mpv {hint-url}')

config.bind(',u', 'spawn umpv {url}')
config.bind(',U', 'hint links spawn umpv {hint-url}')
config.bind(';U', 'hint --rapid links spawn umpv {hint-url}')

# Aliases
c.aliases['proxy-mitm'] = 'set content.proxy http://127.0.0.1:8080/'
c.aliases['noproxy'] = 'set content.proxy none'
