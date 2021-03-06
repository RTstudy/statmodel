# matsudo読書メモ

## 1章

* p.2 統計モデルの説明。「データとモデルを対応づける手つづき」とは何を指しているのか？
* p.12「統計モデル」「数理モデル」の概念が腑に落ちておらず、今後が不安。読み進めていくうちに理解できるかもしれないから、とりあえず進んで、分からなくなったら戻ってこよう。

## 2章

* p.26 対数尤度関数の式変形がひと目では分からなかったので、手計算して確かめた。
* p.27 `function`, `sapply`が分からず調べた。
* p.27 *24の注で、推定値と推定量はどう違う？ → 『統計学入門』東京大学出版会 「11.2.1 推定量と推定値」を読んで解決した。
* p.32 図2.10を見て、統計モデルが少し分かった。観測データの裏に存在すると仮定する母集団のことか。

## 3章

* p.45 plot関数では、pchでプロットのマーカーを指定する。参考: [53. グラフィックスパラメータ（弐）](http://cse.naro.affrc.go.jp/takezawa/r-tips/r/53.html)
* p.45 なぜ「この例題についても、ポアソン分布を使ってデータのばらつきを表現できそう」と言えるのか？
* p.47 線形予測子とリンク関数のことを知らなかったので、[2 3.GLMの基礎](https://www.slideshare.net/logics-of-blue/2-3glm)で学んだ。
* p.51 標準誤差と標準偏差ってどう違うのか、よく分からなくなる。
    > 標準誤差（SE：standard error）は推定量の標準偏差であり、標本から得られる推定量そのもののバラつき（＝精度）を表すものです。
    [18-5. 標準偏差と標準誤差 | 統計Web](https://bellcurve.jp/statistics/course/8616.html#:~:text=%E6%A8%99%E6%BA%96%E8%AA%A4%E5%B7%AE%E3%81%AF%E3%80%81%E4%B8%80%E8%88%AC%E7%9A%84,%E6%A5%B5%E9%99%90%E5%AE%9A%E7%90%86%E3%82%92%E4%BD%BF%E3%81%84%E3%81%BE%E3%81%99%E3%80%82&text=%E3%82%92%E7%94%A8%E3%81%84%E3%82%8B%E3%81%93%E3%81%A8%E3%81%8B%E3%82%89%E3%80%81%E6%A8%99%E6%9C%AC,%E5%BC%8F%E3%81%8B%E3%82%89%E8%A8%88%E7%AE%97%E3%81%A7%E3%81%8D%E3%81%BE%E3%81%99%E3%80%82)
* p.58 最大対数尤度が-235.2の場合と-235.4の場合だと、当てはまりの良さはどのくらい変わるのだろうか。-100を超えると一般的に当てはまりが悪いといった基準はある？ → 第4章で検討するらしい。(p.58下部)
* p.61 yが正規分布していると、あるデータ点iにおいて平均値がμ_i=β1+β2x_iになるものなのか？
* p.61 「恒等リンク関数を使ったポアソン回帰」と「直線回帰」の違いがわからなくなった。 → [ポアソン回帰](https://oku.edu.mie-u.ac.jp/~okumura/stat/poisson_regression.html)を読んで解決。奥村先生ありがとうございます。


## 4章

* p.74 フルモデルの場合は、尤度関数の値が1、対数尤度関数の値が0になるのではないか？
    - pp.24-26の対数尤度関数の定義に戻って、そうではないことを理解した。
    - フルモデルの場合は、観測した各x_iにポアソン分布のピーク(λ)が来る。
* p.76 表4.2で、モデルf, x, f+xのパラメータ数(k)が、2, 2, 3となる理由がわからない。
    - pp.52-59まで戻って、理解できた。線形予測子の項数がパラメータ数となる。
* p.81 最大対数尤度、平均対数尤度、AICはどう違う？
    - 最大対数尤度：モデルのパラメータを変えたときに、その尤度関数の最大値。たまたま得られた観測値における、モデルの当てはまりの良さを表す指標（最大対数尤度が大きいほうが当てはまりが良い）
    - 平均対数尤度：モデルの予測能力の良さを示す指標（平均対数尤度が大きいほうが良いモデル）
    - AIC：平均対数尤度に-2をかけたもの。モデルの予測能力の悪さを示す指標（AICが小さい方が良いモデル）
* p.83 バイアスbの標本平均は0にならないのはなぜ？
    - 試行を繰り返したとき、最大対数尤度logL*の平均は、平均対数尤度E(logL)に一致するのかと思った。
    - 数理統計学の教科書に導出が載っているらしい。
* （感想）新しい概念がたくさん出てきたが、ところどころに入れられている図表が効果的で、理解を助けてくれた。図表は大事。


## 5章

* p.99 第1種の過誤、第2種の過誤の参考資料
    - [Wikipedia | 第一種過誤と第二種過誤](https://ja.wikipedia.org/wiki/%E7%AC%AC%E4%B8%80%E7%A8%AE%E9%81%8E%E8%AA%A4%E3%81%A8%E7%AC%AC%E4%BA%8C%E7%A8%AE%E9%81%8E%E8%AA%A4)
    - [統計Web | 23-4. 第1種の過誤と第2種の過誤](https://bellcurve.jp/statistics/course/9315.html) 
    - 現代数理統計学（竹村） 第8章 検定論

## 6章

* p.114 表6.1 全ての確率分布がGLMに使えるのだろうか？
* p.119 なぜこのセクションでいきなりロジスティック回帰の話が始まったのか分からなかった。
    - 例題データを使って予測するのにロジスティック回帰が適切だから、ということであれば、なぜそう言えるのか？
* p.123 図6.6(B)の意味が分からない。
    - 前にも同じようなグラフがあったことを思い出し、p.61 図3.9(B)と見比べたら理解できた。
* p.127 表6.2 フルモデルの線形予測子はどのようになるのか？
* p.130 ロジスティック回帰を使うと割算値を使わなくて良くなる理由がわからない。
    - 6.6.1 割算値いらずのオフセット項わざ を読んで理解した。 
* p.137 最終パラグラフ（正規分布を使った統計モデルのあてはめとして～）が理解できなかった。
* Rのコードは飛ばした。以後の理解のためにRの文法をもう一度復習した方が良さそう。

## 7章

* p.147 『xi=4のときには、生存確率がlogistic(-2.15+0.51×4)=0.47である二項分布となるはずです。』 そもそもロジスティック回帰の目的って何だっけ？
    * ロジスティック回帰の目的：確率の推定
    * 回帰といっても、何を推定するのかは種類によってまちまち
* p.152 図7.5 r_i>0, r_i=0, r_i<0でグラフの形が変わるのはなぜ？
    * r_iはグラフの切片ではなく、logit(q_i)の入力値だから
* p.155 r_iを推定するために、なぜ積分が必要になるのか。単純に最尤推定するパラメータが1つ増える(s)だけではないのか。
* 個体差のばらつきsが指すものがイメージできなかったが、図7.11を見て理解できた。
* p.163 「反復」とは一般的には同じことを繰り返すことだが、図7.11(A)の場合は何を繰り返しているのか。

## 8章

* 一通り読んだが、「8.3.3 この定常分布は何をあらわす分布なのか？」以降は理解できなかった。要復習。
* p.177 マルコフ連鎖とは
    * [確率過程の基礎 -マルコフ連鎖-](http://bin.t.u-tokyo.ac.jp/startup16/file/2-2.pdf)
* p.177 マルコフ連鎖モンテカルロ法とは
    * [Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%9E%E3%83%AB%E3%82%B3%E3%83%95%E9%80%A3%E9%8E%96%E3%83%A2%E3%83%B3%E3%83%86%E3%82%AB%E3%83%AB%E3%83%AD%E6%B3%95)
* p.177 メトロポリス法以外のMCMCアルゴリズムには何があるか
    * ギブスサンプラー
    * そもそもメトロポリス法はMCMCサンプリングの方法っぽい  
* p.180 「サンプリング」が新しい用語で理解しにくかった。サンプリングとは、ステップ数とともに変化するパラメータの値の生成
    * [第11章 サンプリング法](http://bin.t.u-tokyo.ac.jp/summercamp2015/document/prml11_chika.pdf)
* p.180 中心極限定理によって、定常分布は正規分布になるのだろうか？
* p.182 定常分布を推定するメリットは？
* p.184 メトロポリス法によって得られたパラメータqの確率分布は二項分布に一致するのか？
* p.185 統計モデルのパラメータって何だっけ？
