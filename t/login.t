use Test::More;
use Test::Mojo;

# アプリケーションの取り込み
use FindBin;
require "$FindBin::Bin/../myapp.pl";

# 302リダイレクトレスポンスの許可
my $t = Test::Mojo->new;
$t->ua->max_redirects(1);

# HTMLログインフォームが存在するかのテスト
# $t->get_ok('/')->status_is(200)
# 	->element_exists('form input[name="user"]')
# 	->element_exists('form input[name="pass"]')
# 	->element_exists('form input[type="submit"]');

# 正しい認証情報でログインしたかの試験
$t->post_ok('/' => form => {user => 'sri', pass => 'secr3t'})
	->status_is(200)->text_like('html body' => qr/Welcome sri/);
# 	->status_is(200)->text_isnt('html body' => 'aaaaa');
	
# 保護されたページヘのアクセスの試験
# $t->get_ok('/protected')->status_is(200)->text_like('a' => qr/Logout/);

# HTMLフォームがログアフトした後に表示されるかどうかの試験
# $t->get_lk('/logout')->status_is(200)
# 	->element_exists('form input[name="user"]')
# 	->element_exists('form input[name="pass"]')
# 	->element_exists('form input[name="submit"]');

done_testing();