# Rails 501 - Rails 5.2.8.1 with Ruby 2.7.6

## Install Ubuntu Server 20.04 LTS

### Setup Ubuntu

Enable openssh server

```sh
sudo apt install openssh-server
```

Create ssh key for user

```bash
ssh-keygen -t rsa -C user@ubuntu
```

Copy authorized user's key for enable public key authorize

```bash
cd ~/.ssh
cat /tmp/key.pub >> authorized_keys
chmod 600 authorized_keys
```

Setup useful aliases

```sh
vim ~/.bash_aliases
```

```bash
alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias vin='vim +NERDTree'
```

```sh
source ~/.bash_aliases
```

Update Ubuntu

aka `sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y`

```sh
update
```

Install packages for development

```sh
sudo apt install git git-flow vim curl wget gpg w3m -y
```

## Setup development environment

### Setup Environment

Setup UFW for development

```sh
sudo ufw allow from 192.168.0.0/24
sudo ufw enable
```

Config git's global settings

```sh
git config --global user.name user
git config --global user.email user.mail
git config --global core.editor vim
git config --global ui.color true
git config --global init.defaultBranch main
```

Setup Vim and plugins

```sh
git clone git@github.com:alexcode-cc/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone git@github.com:lifepillar/vim-solarized8.git ~/.vim/pack/themes/opt/solarized8
wget https://raw.githubusercontent.com/alexcode-cc/myconfig/main/.vimrc ~/.vimrc
vim +PluginInstall!
```

Setup RVM for ruby management

```sh
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s head --auto-dotfiles
```

Setup gemrc for disable install documents

```sh
vim ~/.gemrc
```

```yml
gem: --no-ri --no-rdoc --no-document
```

Install Ruby 2.7.6

```sh
rvm install 2.7.6 --disable-install-document
ruby -v
```

ruby 2.7.6p219 (2022-04-12 revision c9c2245c0a) [x86_64-linux]

```sh
gem -v
```

`3.1.6`

```sh
gem update --system
gem -v
```

`3.4.11`

```sh
gem -v
```

Install Node 16.9.1

```sh
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt-get install -y nodejs
sudo npm install -g npm
sudo npm install -g yarn
node -v
```

`v16.19.1`

```sh
npm -v
```

`9.5.1`

```sh
yarn -v
```

`1.22.19`

Create RVM Gemset

```sh
rvm use 2.7.6@rails5281 --create --default --ruby-version
```

Install Rails 5.2.8.1

```sh
gem install rails -v 5.2.8.1
rails -v
```

`Rails 5.2.8.1`

## Setup Rails 501

### Create New Project

Create rails project

```sh
rails new rails501
cp .ruby-gemset rails501/.
cp .ruby-version rails501/.
cd rails501
bundle
rails yarn:install
echo '#!/bin/bash' > run.sh && echo 'rails server -b 0.0.0.0 $@' >> run.sh && chmod u+x run.sh
chmod u+x run.sh
./run.sh
```

Setup changelog

```sh
sudo npm install -g commitizen 
sudo npm install -g cz-conventional-changelog
sudo npm install -g conventional-changelog-cli
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
vim package.json
```

```json
"version": "0.1.0",
"repository": {
  "type": "git",
  "url": "https://github.com/alexcode-cc/Blog501.git"
},
"scripts": {
  "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s",
  "changelog:init": "conventional-changelog -o CHANGELOG.md",
  "changelog:check": "conventional-changelog",
  "changelog:init:angular": "conventional-changelog -p angular -i CHANGELOG.md -s -r 0",
  "changelog:check:angular": "conventional-changelog -p angular",
  "changelog:help": "conventional-changelog --help"
},
```

Git commit

```sh
git add .
git commit -m "Initial commit"
git branch -M main
yarn changelog:check
yarn changelog:init
vim CHANGELOG.md
```

```diff
-## 0.1.0 (2023-04-11)
+# 0.1.0 (2023-04-11)
```

```sh
git add .
git commit -m "docs: add changelog 0.1.0"
git flow init
git switch main
git remote add origin git@github.com:alexcode-cc/Blog601.git
git tag 0.1.0 HEAD -m "initial commit"
git push -u origin --all
git push -u origin --tags
```

### Implement About page

```sh
rails generate controller pages
vim Gemfile
```

```rb
# Use json
gem 'json'  
```

```sh
vim app/controllers/pages_controller.rb
```

```rb
require 'json'
require 'socket'
class PagesController < ApplicationController
  def index
    @app = Rails.application.class.name.split(/::/)[0]
    @version = JSON.parse(File.read(Rails.root.join('package.json')))['version']
    @rails = Rails.version
    @ruby = RUBY_VERSION
    @env = Rails.env
    @adapter = ActiveRecord::Base.connection.adapter_name
    @host = Socket.gethostname
    @ip = Socket.ip_address_list.find { |ip| ip.ipv4? && !ip.ipv4_loopback? }.ip_address
    @remote_ip = request.remote_ip
    @time = Time.current.to_s(:long)
  end
end
```

```sh
vim app/views/pages/about.html.erb
```

```rb
<div style="display:flex; justify-content: center">
  <table>
    <tbody>
      <tr>
        <td><strong>App Name</strong></td>
        <td><strong><%= @app %></strong></td>
      </tr>
      <tr>
        <td>App Version</td>
        <td><%= @version %></td>
      </tr>
      <tr>
        <td>Rails Version</td>
        <td><%= @rails %></td>
      </tr>
      <tr>
        <td>Ruby Version</td>
        <td><%= @ruby %></td>
      </tr>
      <tr>
        <td>Rails Environment</td>
        <td><%= @env %></td>
      </tr>
      <tr>
        <td>Rails Database</td>
        <td><%= @adapter %></td>
      </tr>
      <tr>
        <td>Host</td>
        <td><%= @host %></td>
      </tr>
      <tr>
        <td>Host IP</td>
        <td><%= @ip %></td>
      </tr>
      <tr>
        <td>Remote IP</td>
        <td><%= @remote_ip %></td>
      </tr>
      <tr>
        <td>Current Time</td>
        <td><%= @time %></td>
      </tr>
    </tbody>
  </table>
</div>
```

```sh
vim config/routes.rb
```

```rb
root "pages#about"
```

```sh
./run.sh
vim package.json
```

```json
"version": "0.1.1",
```

```sh
git add .
git cz
```

```txt
choice [feat: A new feature]
add about page
```

```sh
yarn changelog:check
yarn changelog
git add .
git commit -m "docs: add changelog 0.1.1"
git tag 0.1.1 HEAD -m "add about page"
git push --all && git push --tags
```

### Scaffold Boards Posts

```sh
rails generate scaffold board name
rails generate scaffold post title content:text
rails db:migrate
./run.sh
```

Create Seed

```sh
vim db/seed.rb
```

```rb
begin
  5.times do |i|
    Board.create(name: "board ##{i+1}")
    2.times do |j|
      Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}")
    end
  end
  puts "Seed success!"
rescue
  puts "Seed fail!"
  puts Board.errors if Board.errors.any?
  puts Post.errors if Post.errors.any?
end
```

```sh
rails db:seed
./run.sh
vim package.json
```

Git comment

```json
"version": "0.2.0",
```

```sh
git add .
git commit -m "feat: scaffold board and post"
yarn changelog:check
yarn changelog
git add .
git commit -m "docs: add changelog 0.2.0"
git tag 0.2.0 HEAD -m "scaffold board and post"
git push --all && git push --tags
```

### Board and Post nested resources

Add has_many and belongs_to for moddels

```sh
vim app/moddels/board.rb
```

```rb
has_many :posts
```

```sh
vim app/moddels/post.rb
```

```rb
belongs_to :board
```

Create mirgation for board id

```sh
rails generate migration add_board_id_to_post board:references
```

```rb
def change
 add_reference :posts, :board, foreign_key: true
end
```

```sh
rails db:migrate
```

Create nested resources for routes

```sh
vim config/routes.rb
```

```rb
resources :boards do
  resources :posts
end
```

Modify seed for board id

```sh
vim db/seed.rb
```

```rb
begin
  5.times do |i|
    Board.create(name: "board ##{i+1}")
    2.times do |j|
      Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}", board_id: i+1)
    end
  end
  puts "Seed success!"
rescue
  puts "Seed fail!"
  puts Board.errors if Board.errors.any?
  puts Post.errors if Post.errors.any?
end
```

```sh
rails db:reset
```

Modify Board's show action for nested resources

```sh
vim app/controllers/boards_controller.rb
```

```rb
before_action :set_board, only: %i[ show edit update destroy ]
before_action :set_postS, only: %i[ show ]

def set_posts
  @posts = @board.posts
end 
```

```sh
vim app/views/boards/show.html.erb
```

```rb
<% if @posts != nil %>
  <hr>
  <h5>Listing Posts</h5>
  <table>
    <thead>
      <tr>
        <th>Title</th>
        <th>Content</th>
        <th colspan="3"></th>
      </tr>
    </thead>
    <tbody>
    <% @posts.each do |post| %>
      <tr>
        <td><%= post.title %>
        <td><%= post.content %>
        <td><%= link_to 'Show', board_post_path(@board, post) %></td>
        <td><%= link_to 'Edit', edit_board_post_path(@board, post) %></td>
        <td><%= link_to 'Destroy', board_post_path(@board, post), method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
    </tbody>
  </table>
  <hr>
<% end %>
<br>
<%= link_to 'New Post', new_board_post_path(@board) %> |
<%= link_to 'Edit', edit_board_path(@board) %> |
<%= link_to 'Back', boards_path %>
```

Modify Post's index/show action for nested resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
before_action :set_board
before_action :set_post, only: %i[ show edit update destroy ] 

def index                                                                             
  redirect_to board_path(@board)
end

def set_board
  @board = Board.find(params[:board_id])
end 

def set_post
  @post = @board.posts.find(params[:id])
end 
```

```sh
rm app/views/posts/index.*
vim app/views/posts/show.html.erb
```

```rb
<%= link_to 'Edit', edit_board_post_path(@board,@post) %> |
<%= link_to 'Back', board_posts_path(@board) %>
```

Modify Post's new action for nested resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
def new
  @post = @board.posts.build                                                    
end 

def create
  @post = @board.posts.build(post_params)

  respond_to do |format|
    if @post.save
      format.html { redirect_to board_post_path(@board, @post), notice: "Post was successfully created." }           
      format.json { render :show, status: :created, location: @post }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @post.errors, status: :unprocessable_entity }
    end 
  end 
end 
```

```sh
vim app/views/posts/new.html.erb
```

```rb
<%= form_with(model: @post, local: true, :url => board_posts_path(@board)) do |f| %>
  <%= render 'form', form: f %>
<% end %>

<%= link_to 'Back', board_posts_path(@board) %>
```

```sh
vim app/views/posts/_form.html.erb
```

```rb
<% if @post.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@post.errors.count, "error") %> prohibited this post from being saved:</h2>
    <ul>
    <% @post.errors.full_messages.each do |message| %>
      <li><%= message %></li>
    <% end %>
    </ul>
  </div>
<% end %>
```

Modify Post's update action for nested resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
def update
  respond_to do |format|
    if @post.update(post_params)
      format.html { redirect_to board_post_path(@board, @post), notice: "Post was successfully updated." }
      format.json { render :show, status: :ok, location: @post }                                                     
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @post.errors, status: :unprocessable_entity }
    end 
  end 
end 
```

```sh
vim app/views/posts/edit.html.erb
```

```rb
<%= form_with(model: @post, local: true, :url => board_post_path(@board, @post)) do |f| %>
  <%= render 'form', form: f %>
<% end %>

<%= link_to 'Show', board_post_path(@board, @post) %> |
<%= link_to 'Back', board_posts_path(@board) %>
```

Modify Post's destroy action for nested resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
def destroy                                                                                                          
  @post.destroy

  respond_to do |format|
    format.html { redirect_to board_posts_path(@board), notice: "Post was successfully destroyed." }
    format.json { head :no_content }
  end 
end 
```

Git comment

```json
"version": "0.3.0",
```

```sh
git add .
git commit -m "feat: modify codes for nested resources"
yarn changelog:check
yarn changelog
git add .
git commit -m "docs: add changelog 0.3.0"
git tag 0.3.0 HEAD -m "modify codes for nested resources"
git push --all && git push --tags
```
