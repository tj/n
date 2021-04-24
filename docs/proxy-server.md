# Proxy Server

Under the hood, `n` uses `curl` or `wget` for the downloads. `curl` is used if available, and `wget` otherwise. Both `curl` and `wget` support using environment variables or startup files to set up the proxy.

## Using Environment Variable

You can define the proxy server using an environment variable, which is read by multiple commands including `curl` and `wget`:

    export https_proxy='https://host:port/path'

If your proxy requires authentication you can add the [url-encoded](https://urlencode.org) username and password into the URL. e.g.

    export https_proxy='https://encoded-user:encoded-password@host:port/path'

If you have defined a custom node mirror which uses http, then you would define `http_proxy` rather than `https_proxy`.

## Certificate Checks

Your proxy server may supply its own ssl certificates for remote sites (as a man-in-the-middle). If you can not arrange to trust the proxy in this role, you can turn off (all) certificate checking with `--insecure`. e.g.

    n --insecure --lts

Another possible work-around for certificate problems is to use plain http by specifying a custom node mirror:

    export NODE_MIRROR='http://nodejs.org/dist'
    export http_proxy='http://host:port/path'
    n --lts

## Startup Files

An alternative to using an environment variable for the proxy settings is to configure a startup file for the command.

Example `~/.curlrc` ([documentation](https://ec.haxx.se/cmdline-configfile.html))

    proxy = http://host:port/path
    proxy-user = user:password
    # If need to disable certificate checks
    --insecure

Example `~/.wgetrc` ([documentation](https://www.gnu.org/software/wget/manual/html_node/Wgetrc-Commands.html#Wgetrc-Commands))

    https_proxy = http://host:port/path
    proxy_user = user
    proxy_password = password
    # If need to disable certificate checks
    check_certificate = off

## Troubleshooting

To experiment and find what settings you need, use `curl` (or `wget`) directly with the node mirror and check the error messages.

For these examples there is a proxy running on localhost:8080 which does not require authentication, but the certificates it offers
are not trusted.

First try fails because of the certificates and `curl` helpfully explains:

    $ curl --proxy localhost:8080 https://nodejs.org/dist/
    curl: (60) SSL certificate problem: self signed certificate in certificate chain
    ...
    If you'd like to turn off curl's verification of the certificate, use
    the -k (or --insecure) option.
    HTTPS-proxy has similar options --proxy-cacert and --proxy-insecure.

Once you get the command to work with settings appropriate for your setup, like:

    $ curl --insecure --proxy localhost:8080 https://nodejs.org/dist/
    <html>
    <head><title>Index of /dist/</title></head>
    ...

then you can try moving the proxy out of the command:

    $ https_proxy=localhost:8080 curl --insecure https://nodejs.org/dist/
    <html>
    <head><title>Index of /dist/</title></head>
    ...

and then `n` should work the same way:

    $ https_proxy=localhost:8080 n --insecure --lts
    8.11.3

To make it permanent either add settings to the `curl` (or `wget`) startup file, or add the
environment variable to your shell initialization file . e.g.

    export https_proxy=localhost:8080

For curl, two options of note for debugging are:

    -v, --verbose
    Makes curl verbose during the operation. Useful for debugging and seeing what's going on "under the hood". ...

    -q, --disable
    If used as the first parameter on the command line, the curlrc config file will not be read and used. ...
