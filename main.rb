require 'ruby2d'

module Config
    SCREEN_WIDTH = 1280
    SCREEN_HEIGHT = 720

    BOARD_COLUMNS = 6
    BOARD_ROWS = 3

    PANEL_SIZE = 20
    PANEL_GAP = 5
end

module GroundType
    NORMAL = 0
    ALMOST_BROKEN = 1
    BROKEN = 2
    EMPTY = 3
    POISON = 4
    SANCTUARY = 5
    GRASS = 6
    ICE = 7
end

class Navi
    def initialize(team, board)
        @team = team
        @position = board.team_2D_1D(@team, 2, 2)
        @board = board

    end

    def draw()
        rect = Rectangle.new(x: 0, y: 0, width: Config::PANEL_SIZE * 0.8, height: Config::PANEL_SIZE * 1.2, color: @team == 1? 'white': 'green') 
        rect.add
    end

    def events()
        if @team == 2
            return
        end
        
        # on :key_down do |event|
            # if event.key == 'a'
                # puts 'left'
            # elsif event.key == 'd'
                # puts 'right'
            # elsif event.key == 'w'
                # puts 'up'
            # elsif event.key == 's'
                # puts 'down'
            # end
        # end
    end
end


class Panel
    def initialize(team, index)
        @team = team
        @ground = GroundType::NORMAL
        @index = index
    end

    def add_to_scene()
        col = @index % Config::BOARD_COLUMNS
        row = (@index / Config::BOARD_COLUMNS).floor
        panel_color = nil

        case @ground
        when GroundType::NORMAL then
            panel_color = @team == 1? 'blue' : 'red' 
        when GroundType::EMPTY then
            panel_color = 'black' 
        end

        if panel_color != nil then
            panel_graphic = Square.new(x: col * (Config::PANEL_SIZE + Config::PANEL_GAP), y: row * (Config::PANEL_SIZE + Config::PANEL_GAP), size: Config::PANEL_SIZE, color: panel_color)
            panel_graphic.add
        end
    end
end

class Board
    @@columns = Config::BOARD_COLUMNS 
    @@rows = Config::BOARD_ROWS
    def initialize()
        total_cells = @@rows * @@columns
        @panels = Array.new(total_cells)
        (0...total_cells).each do  |i| 
            @panels[i] = Panel.new(i % 6 <= 2? 1: 2, i)
        end

        @panels.each do |panel|
            panel.add_to_scene
        end
    end

    def all_2D_1D(col, row)
        return col + row * @@columns
    end

    def team_2D_1D(team, col, row)
        return all_2D_1D(col, row) + team == 1? 0: @@columns / 2
    end

    def all_1D_2D(index) 
        col = (index % @@columns) 
        row = (index / @@columns).floor
        return col, row
    end

    def team_1D_2D(team, index)
        col, row = all_1D_2D(index)
        if team == 2
            col += @@columns / 2
        end
        return col, row
    end

end

set title: "MMBN Mechanics"
set background: 'gray'
set width: Config::SCREEN_WIDTH, height: Config::SCREEN_HEIGHT 

board = Board.new
player = Navi.new(1, board)
enemy = Navi.new(2, board)

# player.draw
# enemy.draw

player.events
enemy.events

tick = 0
update do
    if tick % 60 == 0
        set background: 'random'
    end
    tick += 1
end

show