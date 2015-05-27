play2 Cookbook
==============
This cookbook install [playframework 2](http://www.playframework.com)

Attributes
----------
#### play2::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['play2']['version']</tt></td>
    <td>String</td>
    <td>The framework version</td>
    <td><tt>2.1.0</tt></td>
  </tr>
  <tr>
    <td><tt>['play2']['checksum']</tt></td>
    <td>String</td>
    <td>Zip checksum</td>
    <td><tt>0eef88602d26409bb584536cedb585de</tt></td>
  </tr>
  <tr>
    <td><tt>['play2']['url']</tt></td>
    <td>String</td>
    <td>The download url part</td>
    <td><tt>http://downloads.typesafe.com/play/</tt></td>
  </tr>
  <tr>
    <td><tt>['play2']['home']</tt></td>
    <td>String</td>
    <td>Installation destination</td>
    <td><tt>/usr/local/play</tt></td>
  </tr>

</table>

Usage
-----
#### play2::default
Just include `play2` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[play2]"
  ]
}
```

License and Authors
-------------------
Author:: Didier Bathily (<bathily@njin.fr>)

Copyright 2013, njin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
