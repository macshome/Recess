import UIKit

var components = URLComponents()
components.scheme = "https"
components.host = "foo.jamf.com"
components.path = "/endpoint"
components.url!
let string = "https://sso.jamflabs.io/common/oauth2/v2.0/authorize?client_id=4765445b-32c6-49b0-83e6-1d93765276ca&redirect_uri=https%3A%2F%2Fwww.office.com%2Flandingv2&response_type=code%20id_token&scope=openid%20profile%20https%3A%2F%2Fwww.office.com%2Fv2%2FOfficeHome.All&response_mode=form_post&nonce=637884113664543453.ZjcyYzU5ZTctZDZmNy00NzIyLTg2MDctY2ZjOGI5MmE2NGEzOGYzOTg5N2EtYjIzNC00NGM3LTgwMzktNTQwNjg4MmQ3MTlk&ui_locales=en-US&mkt=en-US&client-request-id=a2999af1-2f3b-4239-8a43-70129ef21f6c&state=ZUC4LCX02OZxdX7Fk8IoxuIpis7z-x2o5i2TocidjOQWDXlMfadgFxYUYQWma8s9UwIkkD_iEPSLYHmhOGgIUawmXM0zm3UdWK8rDpDAXaQ2uPRYaYyQRqxvmxqKp5koYkq9vToPAHUaZkx4Me1TH4GtceqQVmWzRqWr7ALalA963D59HKqYGvr2eoOZaWHxqpMj7KDDl51SkqtaT0o5EhUwtyFFnApWSixty7bjxRZj5LDyfeDs64uJhBF5ouGHMh6RainvRObJEnJnl88F2g&x-client-SKU=ID_NETSTANDARD2_0&x-client-ver=6.12.1.0"
let url = URL(string: string)!
url.description
url.path
url.port
url.baseURL
url.query
url.lastPathComponent
url.fragment
url.host
url.pathExtension
url.scheme
let foo = URLComponents(url: url, resolvingAgainstBaseURL: false)
foo?.queryItems?.first?.value
foo?.host

components.host = url.host

func getQueryURL(_ url: URL) -> URL? {
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    components?.queryItems
   if let idpHost = components?.queryItems?.first?.value {
       components?.host = idpHost
//       components?.query = nil
       return components?.url
    }
    return nil
}

getQueryURL(url)
