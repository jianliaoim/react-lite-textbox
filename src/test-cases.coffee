
exports.basic =
  text: 'a'
  start: 1

exports.newline =
  text: 'a\na'
  start: 4

exports.emptyLine =
  text: 'a\n\n\n\n'
  start: 4

exports.longLine =
  text: 'What once started as a simple word of mouth soon turned into newspapers, followed by radio and then TV. Media industry has been one of the most disrupted by the Internet, but just when you thought it has finally hit its stride here comes the new disrupter — Virtual Reality.'
  start: 80

exports.chinese =
  text: '整个 SB 的做工看起来还是很高端的，材质上确实和 mbp 看起来差不多。对于 SB 来说，最炫酷的自然是把屏幕分离下来。最让人感到讶异的就是，分离下来的屏幕非！常！轻！薄！，我甚至认为 SB 的屏幕部分比 SP3 还要轻！薄！可能对于便携性重度需求来说，这一点很重要。'
  start: 40

exports.chineseLines =
  text: """残寒正欺病酒，掩沉香绣户。燕来晚、飞入西城，似说春事迟暮。画船载、清明过却，晴烟冉冉吴宫树。念羁情、游荡随风，化为轻絮。

　　十载西湖，傍柳系马，趁娇尘软雾。溯红渐招入仙溪，锦儿偷寄幽素，倚银屏、春宽梦窄，断红湿、歌纨金缕。暝堤空，轻把斜阳，总还鸥鹭。

　　幽兰旋老，杜若还生，水乡尚寄旅。别后访、六桥无信，事往花委，瘗玉埋香，几番风雨。长波妒盼，遥山羞黛，渔灯分影春江宿。记当时、短楫桃根渡，青楼仿佛，临分败壁题诗，泪墨惨淡尘土。危亭望极，草色天涯，叹鬓侵半苎。暗点检、离痕欢唾，尚染鲛绡，亸凤迷归，破鸾慵舞。殷勤待写，书中长恨，蓝霞辽海沉过雁。漫相思、弹入哀筝柱。伤心千里江南，怨曲重招，断魂在否？"""
  start: 40

exports.abnormal30 =
  text: 'aaaaaaaaaaaaaaaaaaaaaaaa bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb cccccccccccccccccccccccc'
  start: 30

exports.webpackLog =
  text: """  Asset      Size  Chunks             Chunk Names
                             main.js    808 kB       0  [emitted]  main
                           vendor.js    209 kB       1  [emitted]  vendor
0.c9994ff3afdf9f709085.hot-update.js   1.48 kB       0  [emitted]  main
c9994ff3afdf9f709085.hot-update.json  36 bytes          [emitted]
chunk    {0} main.js, 0.c9994ff3afdf9f709085.hot-update.js """
  start: 40

exports.binaryTree =
  text: """      A
     /
    B
   / \
  C   D
     / \
    E   F
     \
      G"""
  start: 30

exports.code =
  text: """template <typename T>
void traverse_non_recursive_3(node<T> const & _t)
{
    stack<node<T> const *> s;
    s.push(&_t);
    bool bt = false;

    while(!s.empty()) {
        node<T> const & t = *s.top();

        if(!bt) {
            cout << t.val() << endl;
            if(t.hasl()) { bt = false; s.push(&t.left()); }
            else bt = true;
        } else {
            if(t.hasr()) { bt = false; s.top() = &t.right(); }
            else { s.pop(); bt = true; }
        }
    }
}"""
  start: 50
