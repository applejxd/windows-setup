#
# Placeholder Python module for additional response parsers.
#
# Copy this file into the "Profile\Packages\WebSuggest" folder so Keypirinha
# can load your callback(s) at runtime.
# You may need to create the "WebSuggest" folder first.
#
# Your functions can have any arbitrary name that is supported by the Python
# language. Do not forget to reference them using the *api_parser* setting.
#
# Here is how the default "opensearch" parser is implemented:

import traceback
import xml.etree.ElementTree as ET
import urllib.request


def default_parser(plugin, provider, response):
    try:
        response = response.decode(encoding="utf-8", errors="strict")
        return json.loads(response)[1]
    except:
        plugin.warn("Failed to parse response from provider {}.".format(
            provider.label))
        traceback.print_exc()
        return []


def my_parser(plugin, provider, response: bytes):
    try:
        # get ID from the response
        response_str: str = response.decode(encoding="utf-8", errors="strict")
        response_elem = ET.fromstring(response_str)
        id_elem = response_elem.find(
            './/{http://btonic.est.co.jp/NetDic/NetDicV09}'+'ItemID')
        id_txt: str = id_elem.text

        # search the definition
        url: str = 'http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite?Dic=EJdict&Loc=&Prof=XHTML&Item=' + id_txt
        xml = urllib.request.urlopen(url)
        tree = ET.parse(xml)
        root = tree.getroot()
        def_elem = root.find(
            './/{http://btonic.est.co.jp/NetDic/NetDicV09}' + 'Body/div/div')
        def_txt: str = def_elem.text

        # split words
        splitted_def_txt: List[str] = def_txt.split("\t")

        return splitted_def_txt
    except:
        plugin.warn("Failed to parse response from provider {}.".format(
                    provider.label))
        traceback.print_exc()
        return []


# for debugging
if __name__ == '__main__':
    test_data = open('response.xml', mode='rb').read()
    print(my_parser('test', 'test', test_data))
