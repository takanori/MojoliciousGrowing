package MyApp;
use Mojo::Base 'Mojolicious';

use MyUsers;

sub startup {
	my $self = shift;
	
	$self->secret('Mojolicious rocks');
	$self->helper(users => sub { state $users = MyUsers->new });
	
	my $r = $self->routes;
	
	$r->any('/' => sub {
		my $self = shift;
		
		my $user = $self->param('user') || '';
		my $pass = $self->param('pass') || '';
		return $self->render unless $self->users->check($user, $pass);
		
		$self->session(user => $user);
		$self->flash(message => 'Thanks for logging in.');
		$self->redirect_to('protected');
	} => 'index');
	
	my $logged_in = $r->under(sub {
		my $self = shift;
		return $self->session('user') || !$self->redirect_to('index');
	});
	$logged_in->get('/protected');
	
	$r->get('/logout' => sub {
		my $self = shift;
		$self->session(expires => 1);
		$self->redirect_to('index');
	});
}

1;