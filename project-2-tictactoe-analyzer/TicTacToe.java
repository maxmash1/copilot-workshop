import java.util.Scanner;

public class TicTacToe {
    static char[][] board = new char[3][3];
    static boolean gameRunning = true;
    static char currentPlayer = 'X';

    public static void main(String[] args) {
        initializeBoard();
        while (gameRunning) {
            printBoard();
            handlePlayerMove();
            checkGameOver();
            switchPlayer();
        }
    }

    static void initializeBoard() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                board[i][j] = '-';
            }
        }
    }

    static void printBoard() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                System.out.print(board[i][j] + " ");
            }
            System.out.println();
        }
    }

    static void handlePlayerMove() {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Player " + currentPlayer + ", enter your move (row [1-3] and column [1-3]):");
        int row = scanner.nextInt() - 1;
        int col = scanner.nextInt() - 1;
        board[row][col] = currentPlayer;
    }

    static void checkGameOver() {
        for (int i = 0; i < 3; i++) {
            if (board[i][0] == currentPlayer && board[i][1] == currentPlayer && board[i][2] == currentPlayer) {
                gameRunning = false;
                System.out.println("Player " + currentPlayer + " wins!");
                return;
            }
            if (board[0][i] == currentPlayer && board[1][i] == currentPlayer && board[2][i] == currentPlayer) {
                gameRunning = false;
                System.out.println("Player " + currentPlayer + " wins!");
                return;
            }
        }
        if (board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer) {
            gameRunning = false;
            System.out.println("Player " + currentPlayer + " wins!");
            return;
        }
        if (board[0][2] == currentPlayer && board[1][1] == currentPlayer && board[2][0] == currentPlayer) {
            gameRunning = false;
            System.out.println("Player " + currentPlayer + " wins!");
            return;
        }
    }

    static void switchPlayer() {
        if (currentPlayer == 'X') {
            currentPlayer = 'O';
        } else {
            currentPlayer = 'X';
        }
    }
}
