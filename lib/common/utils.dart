// Author: d1y<chenhonzhou@gmail.com>
// Date: 2021/09/10 <about/util>

/// easy kv typedef
///
typedef MapKV = Map<String, String> Function(List<String>);

/// default syb
const syb = "=";

Map<String, String> getLinesKV(List<String> lines) {
  var result = new Map<String, String>();
  lines.map((item) {
    var cacheList = item.split(syb);
    if (cacheList.length == 2) {
      var k = cacheList[0];
      String v = cacheList[1];

      /// NOTE: 删除 '/" 引号
      if (v[0] == '"' || v[0] == "'") {
        v = v.substring(1, v.length - 1);
      }
      result[k] = v;
    }
  }).toList();
  return result;
}
