import json
import sys
from typing import Dict, List

# path = sys.argv[1]
path = r"./info_pre.json"

with open(path) as f:
    d = json.load(f)

layout = d["layouts"]["LAYOUT"]["layout"]

for i in range(len(layout)):
    pos = layout[i]["label"].split(",")
    layout[i]["matrix"] = [int(num) for num in pos]


def serialize(obj, level=0) -> str:
    indent = 2
    if isinstance(obj, Dict):
        dict_str = " " * indent * level + "{\n"
        for key, value in obj.items():
            value_str = serialize(value, level+1)
            dict_str += " " * indent * (level+1) + f"\"{str(key)}\": {value_str},\n"
        # 末尾のカンマ削除
        dict_str = dict_str[:-2] + "\n"
        dict_str += " " * indent * level + "}"
        return dict_str
    elif isinstance(obj, List):
        list_str = " " * indent * level + "[\n"
        for item in obj:
            list_str += " " * indent * (level+1) + "{"
            list_str += f"\"label\": \"{item['label']}\", "
            list_str += f"\"x\": {item['x']}, "
            list_str += f"\"y\": {item['y']}, "
            list_str += f"\"matrix\": [{item['matrix'][0]}, {item['matrix'][1]}]"
            list_str += "},\n"
        # 末尾のカンマ削除
        list_str = list_str[:-2] + "\n"
        list_str += " " * indent * level + "]" 
        return list_str
    elif isinstance(obj, str):
        return f"\"{obj}\""
    elif len(obj) == 0:
        return "\"\""
    else:
        raise RuntimeError("error")
        
dict_str = serialize(d)
with open(r"./info.json", "w", encoding="UTF-8") as f:
    f.write(dict_str)
