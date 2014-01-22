#!/bin/bash

SESSION=zvg
tmux -2 new-session -A -d -s $SESSION

# Window for aux (python server and coffee parser)
tmux new-window -t $SESSION:1 -n 'aux'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "python -m SimpleHTTPServer 8001" C-m
tmux select-pane -t 1
tmux split-window -v
tmux select-pane -t 1
tmux send-keys "coffee -o js/zvg/ -cw app/assets/javascripts/zvg" C-m
tmux select-pane -t 2
tmux send-keys "coffee -o js/spec/ -cw spec/coffee" C-m

tmux new-window -t $SESSION:2 -n 'vim'
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "vim" C-m
tmux select-pane -t 1
tmux send-keys "vim" C-m

open http://0.0.0.0:8001/samples
open http://0.0.0.0:8001/spec/tests.html

tmux -2 attach-session -t $SESSION


