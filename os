//Address book
import java.io.*;
import java.util.*;

public class AddressBookManager {
    private static final String FILE_NAME = "address_book2.txt";

    public static void initializeAddressBook() {
        try {
            File file = new File(FILE_NAME);
            if (file.createNewFile()) {
                System.out.println("Address book created.");
            } else {
                System.out.println("Address book already exists.");
            }
        } catch (IOException e) {
            System.out.println("Error creating address book: " + e.getMessage());
        }
    }

    public static void displayAddressBook() {
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_NAME))) {
            String line;
            System.out.println("\n--- Address Book Contents ---");
            while ((line = br.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            System.out.println("Error reading address book: " + e.getMessage());
        }
    }

    public static void addRecord() {
        Scanner scanner = new Scanner(System.in);
        try {
            System.out.print("Enter Roll No: ");
            String rollNo = scanner.nextLine();
            System.out.print("Enter Name: ");
            String name = scanner.nextLine();
            System.out.print("Enter Phone Number: ");
            String phone = scanner.nextLine();

            if (isRecordExists(rollNo)) {
                System.out.println("Record for Roll No " + rollNo + " already exists.");
                return;
            }

            try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_NAME, true))) {
                bw.write(rollNo + " | " + name + " | " + phone);
                bw.newLine();
                System.out.println("Record added successfully.");
            }
        } catch (IOException e) {
            System.out.println("Error adding record: " + e.getMessage());
        }
    }

    public static void removeRecord() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter Roll No of the record to delete: ");
        String rollNo = scanner.nextLine();
        List<String> updatedRecords = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(FILE_NAME))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.startsWith(rollNo + " |")) {
                    updatedRecords.add(line);
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading address book: " + e.getMessage());
        }

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_NAME))) {
            for (String record : updatedRecords) {
                bw.write(record);
                bw.newLine();
            }
            System.out.println("Record deleted successfully.");
        } catch (IOException e) {
            System.out.println("Error updating address book: " + e.getMessage());
        }
    }

    public static void updateRecord() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter Roll No of the record to modify: ");
        String rollNo = scanner.nextLine();
        System.out.print("Enter New Name: ");
        String newName = scanner.nextLine();
        System.out.print("Enter New Phone Number: ");
        String newPhone = scanner.nextLine();

        List<String> updatedRecords = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(FILE_NAME))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith(rollNo + " |")) {
                    updatedRecords.add(rollNo + " | " + newName + " | " + newPhone);
                } else {
                    updatedRecords.add(line);
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading address book: " + e.getMessage());
        }

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_NAME))) {
            for (String record : updatedRecords) {
                bw.write(record);
                bw.newLine();
            }
            System.out.println("Record updated successfully.");
        } catch (IOException e) {
            System.out.println("Error updating address book: " + e.getMessage());
        }
    }

    private static boolean isRecordExists(String rollNo) throws IOException {
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_NAME))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith(rollNo + " |")) {
                    return true;
                }
            }
        }
        return false;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        while (true) {
            System.out.println("\n--- Address Book Menu ---");
            System.out.println("1) Create Address Book");
            System.out.println("2) View Address Book");
            System.out.println("3) Insert Record");
            System.out.println("4) Delete Record");
            System.out.println("5) Modify Record");
            System.out.println("6) Exit");
            System.out.print("Choose an option: ");
            int option;
            try {
                option = Integer.parseInt(scanner.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Invalid input! Please enter a number.");
                continue;
            }

            switch (option) {
                case 1 -> initializeAddressBook();
                case 2 -> displayAddressBook();
                case 3 -> addRecord();
                case 4 -> removeRecord();
                case 5 -> updateRecord();
                case 6 -> {
                    System.out.println("Exiting.");
                    return;
                }
                default -> System.out.println("Invalid option. Please try again.");
            }
        }
    }
}

//forkwala
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>

// Demonstrate Zombie Process
void zombie_demo() {
    pid_t pid = fork();

    if (pid < 0) {
        perror("Fork failed");
        exit(1);
    }

    if (pid == 0) {
        // Child process exits immediately
        printf("Child process started and exiting. PID: %d\n", getpid());
        exit(0);
    } else {
        // Parent sleeps and then waits (during sleep, child is zombie)
        printf("Parent created a child. PID: %d\n", getpid());
        sleep(2); // Gives time to observe zombie in `ps` or `top`
        waitpid(pid, NULL, 0);
        printf("Zombie process reaped by parent. PID: %d\n", getpid());
    }
}

// Demonstrate Orphan Process
void orphan_demo() {
    pid_t pid = fork();

    if (pid < 0) {
        perror("Fork failed");
        exit(1);
    }

    if (pid == 0) {
        // Child becomes orphan after parent exits
        printf("Orphan child process started. PID: %d\n", getpid());
        sleep(5);
        printf("Orphan child process finished. PID: %d\n", getpid());
        exit(0);
    } else {
        // Parent exits immediately, child becomes orphan
        printf("Parent process (will exit) created child. PID: %d\n", getpid());
        exit(0);
    }
}

// Demonstrate execve() system call
void execve_demo() {
    pid_t pid = fork();

    if (pid < 0) {
        perror("Fork failed");
        exit(1);
    }

    if (pid == 0) {
        // Child replaces image with new program
        printf("Child executing execve. PID: %d\n", getpid());
        char *args[] = {"/bin/echo", "Hello", "from", "execve!", NULL};
        execve(args[0], args, NULL);

        // Only prints if execve fails
        perror("execve failed");
        exit(1);
    } else {
        waitpid(pid, NULL, 0);
        printf("Parent finished after execve. PID: %d\n", getpid());
    }
}

int main() {
    printf("Main process started. PID: %d\n", getpid());

    zombie_demo();
    sleep(1); // Ensure zombie demo completes before moving on

    orphan_demo();
    sleep(6); // Wait for orphan child to finish

    execve_demo();

    return 0;
}
gcc process_demo.c -o process_demo
./process_demo
g++ file.cpp -o file
./file

//matrix multiplication
import java.util.Scanner;

class MatrixMultiplierThread extends Thread {
    private int row, col;
    private int[][] A, B, C;

    public MatrixMultiplierThread(int row, int col, int[][] A, int[][] B, int[][] C) {
        this.row = row;
        this.col = col;
        this.A = A;
        this.B = B;
        this.C = C;
    }

    @Override
    public void run() {
        int sum = 0;
        for (int i = 0; i < A[0].length; i++) {
            sum += A[row][i] * B[i][col];
        }
        C[row][col] = sum;
    }
}

public class ParallelMatrixMultiplication {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("\nEnter rows and columns for first matrix: ");
        int rowsA = scanner.nextInt();
        int colsA = scanner.nextInt();

        System.out.print("Enter rows and columns for second matrix: ");
        int rowsB = scanner.nextInt();
        int colsB = scanner.nextInt();

        if (colsA != rowsB) {
            System.out.println("Matrix multiplication is not possible!");
            scanner.close();
            return;
        }

        int[][] A = new int[rowsA][colsA];
        int[][] B = new int[rowsB][colsB];
        int[][] C = new int[rowsA][colsB];

        System.out.println("Enter elements of first matrix:");
        for (int i = 0; i < rowsA; i++)
            for (int j = 0; j < colsA; j++)
                A[i][j] = scanner.nextInt();

        System.out.println("Enter elements of second matrix:");
        for (int i = 0; i < rowsB; i++)
            for (int j = 0; j < colsB; j++)
                B[i][j] = scanner.nextInt();

        Thread[][] threads = new Thread[rowsA][colsB];
        for (int i = 0; i < rowsA; i++) {
            for (int j = 0; j < colsB; j++) {
                threads[i][j] = new MatrixMultiplierThread(i, j, A, B, C);
                threads[i][j].start();
            }
        }

        for (int i = 0; i < rowsA; i++) {
            for (int j = 0; j < colsB; j++) {
                try {
                    threads[i][j].join();
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
        }

        System.out.println("Resultant Matrix:");
        for (int[] row : C) {
            for (int val : row) {
                System.out.print(val + " ");
            }
            System.out.println();
        }

        scanner.close();
    }
}

//bankertype
import java.util.*;

class Process {
    int id, arrival, burst, wait, completion, turnaround, priority;

    Process(int id, int arrival, int burst) {
        this.id = id;
        this.arrival = arrival;
        this.burst = burst;
    }

    Process(int id, int arrival, int burst, int priority) {
        this(id, arrival, burst);
        this.priority = priority;
    }
}

public class SchedulingDemo {

    public static void fcfs(Process[] processes, int n) {
        Arrays.sort(processes, Comparator.comparingInt(p -> p.arrival));
        int currentTime = 0;
        for (Process p : processes) {
            if (currentTime < p.arrival) currentTime = p.arrival;
            p.completion = currentTime + p.burst;
            p.turnaround = p.completion - p.arrival;
            p.wait = p.turnaround - p.burst;
            currentTime = p.completion;
        }
        printTable(processes, n);
    }

    public static void sjf(Process[] processes, int n) {
        List<Process> list = new ArrayList<>(Arrays.asList(processes));
        List<Process> done = new ArrayList<>();
        int currentTime = 0;

        while (!list.isEmpty()) {
            Process next = list.stream()
                    .filter(p -> p.arrival <= currentTime)
                    .min(Comparator.comparingInt(p -> p.burst))
                    .orElse(null);

            if (next == null) {
                currentTime++;
                continue;
            }

            currentTime = Math.max(currentTime, next.arrival);
            next.completion = currentTime + next.burst;
            next.turnaround = next.completion - next.arrival;
            next.wait = next.turnaround - next.burst;
            currentTime = next.completion;

            done.add(next);
            list.remove(next);
        }

        printTable(done.toArray(new Process[0]), n);
    }

    public static void priorityScheduling(Process[] processes, int n, Scanner sc) {
        for (Process p : processes) {
            System.out.print("Enter priority of Process " + p.id + ": ");
            p.priority = sc.nextInt();
        }

        List<Process> list = new ArrayList<>(Arrays.asList(processes));
        List<Process> done = new ArrayList<>();
        int currentTime = 0;

        while (!list.isEmpty()) {
            Process next = list.stream()
                    .filter(p -> p.arrival <= currentTime)
                    .min(Comparator.comparingInt(p -> p.priority))
                    .orElse(null);

            if (next == null) {
                currentTime++;
                continue;
            }

            currentTime = Math.max(currentTime, next.arrival);
            next.completion = currentTime + next.burst;
            next.turnaround = next.completion - next.arrival;
            next.wait = next.turnaround - next.burst;
            currentTime = next.completion;

            done.add(next);
            list.remove(next);
        }

        printTable(done.toArray(new Process[0]), n);
    }

    public static void printTable(Process[] processes, int n) {
        System.out.println("\nID | Arrival | Burst | Completion | Waiting | Turnaround");
        double totalWait = 0, totalTurnaround = 0;

        for (Process p : processes) {
            System.out.printf("%2d | %7d | %5d | %10d | %7d | %10d\n",
                    p.id, p.arrival, p.burst, p.completion, p.wait, p.turnaround);
            totalWait += p.wait;
            totalTurnaround += p.turnaround;
        }

        System.out.printf("Average Waiting Time: %.2f\n", totalWait / n);
        System.out.printf("Average Turnaround Time: %.2f\n", totalTurnaround / n);
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.print("\nEnter number of processes: ");
        int n = sc.nextInt();
        Process[] processes = new Process[n];

        for (int i = 0; i < n; i++) {
            System.out.print("Arrival time of P" + (i + 1) + ": ");
            int arrival = sc.nextInt();
            System.out.print("Burst time of P" + (i + 1) + ": ");
            int burst = sc.nextInt();
            processes[i] = new Process(i + 1, arrival, burst);
        }

        int choice;
        do {
            System.out.println("\nChoose Scheduling Algorithm:");
            System.out.println("1. FCFS");
            System.out.println("2. SJF");
            System.out.println("3. Priority");
            System.out.println("4. Exit");
            System.out.print("Enter choice: ");
            choice = sc.nextInt();

            // Make a deep copy of processes to avoid reusing modified ones
            Process[] cloned = new Process[n];
            for (int i = 0; i < n; i++) {
                cloned[i] = new Process(processes[i].id, processes[i].arrival, processes[i].burst, processes[i].priority);
            }

            switch (choice) {
                case 1 -> fcfs(cloned, n);
                case 2 -> sjf(cloned, n);
                case 3 -> priorityScheduling(cloned, n, sc);
                case 4 -> System.out.println("Exiting...");
                default -> System.out.println("Invalid choice");
            }
        } while (choice != 4);

        sc.close();
    }
}

//semaphores
import java.util.concurrent.Semaphore;
import java.util.Queue;
import java.util.LinkedList;

public class ProducerConsumer {
    private static final int BUFFER_SIZE = 5;
    private static final Queue<Integer> buffer = new LinkedList<>();

    // Semaphores
    private static final Semaphore empty = new Semaphore(BUFFER_SIZE); // Available slots
    private static final Semaphore full = new Semaphore(0);            // Filled slots
    private static final Semaphore mutex = new Semaphore(1);           // Mutex for critical section

    // Producer Thread
    static class Producer extends Thread {
        public void run() {
            try {
                for (int i = 1; i <= 10; i++) {
                    empty.acquire();        // Wait if buffer is full
                    mutex.acquire();        // Enter critical section

                    buffer.add(i);
                    System.out.println("Producer produced: " + i);

                    mutex.release();        // Exit critical section
                    full.release();         // Notify that buffer has an item

                    Thread.sleep(500);      // Simulate production time
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    // Consumer Thread
    static class Consumer extends Thread {
        public void run() {
            try {
                for (int i = 1; i <= 10; i++) {
                    full.acquire();         // Wait if buffer is empty
                    mutex.acquire();        // Enter critical section

                    int item = buffer.poll();
                    System.out.println("Consumer consumed: " + item);

                    mutex.release();        // Exit critical section
                    empty.release();        // Notify that buffer has space

                    Thread.sleep(800);      // Simulate consumption time
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    // Main Method
    public static void main(String[] args) {
        Producer producer = new Producer();
        Consumer consumer = new Consumer();

        producer.start();
        consumer.start();
    }
}
// Basic threading in Java
public class SimpleThreadExample {
    public static void main(String[] args) {
        Runnable myThread = () -> {
            System.out.println("Thread is starting...");
            try {
                Thread.sleep(2000); // 2 seconds
                System.out.println("Thread is running again...");
                Thread.sleep(1000); // 1 second
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("Thread has finished.");
        };

        Thread thread = new Thread(myThread);

        System.out.println("Main: Starting the thread");
        thread.start();

        System.out.println("Main: Waiting for the thread to finish");
        try {
            thread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Main: Thread has completed");
    }
}

//

import java.util.Random;

class SharedResource {
    private int data = 0;

    public synchronized void read() {
        System.out.println("[Reader] Read data: " + data);
    }

    public synchronized void write(int value) {
        System.out.println("[Writer] Writing data: " + value);
        data = value;
        System.out.println("[Writer] New data set to: " + data);
    }
}

abstract class ThreadBase extends Thread {
    protected SharedResource sharedResource;

    public ThreadBase(SharedResource sharedResource) {
        this.sharedResource = sharedResource;
    }

    public abstract void run();
}

class ReaderThread extends ThreadBase {
    public ReaderThread(SharedResource sharedResource) {
        super(sharedResource);
    }

    @Override
    public void run() {
        Random rand = new Random();
        for (int i = 0; i < 3; i++) {
            sharedResource.read();
            try {
                Thread.sleep((long)(rand.nextDouble() * 500 + 500)); // 0.5 to 1 second
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

class WriterThread extends ThreadBase {
    public WriterThread(SharedResource sharedResource) {
        super(sharedResource);
    }

    @Override
    public void run() {
        Random rand = new Random();
        for (int i = 0; i < 3; i++) {
            int value = rand.nextInt(100) + 1;
            sharedResource.write(value);
            try {
                Thread.sleep((long)(rand.nextDouble() * 500 + 500)); // 0.5 to 1 second
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}

public class MultiThreadExample {
    public static void main(String[] args) {
        SharedResource sharedResource = new SharedResource();

        Thread[] threads = new Thread[] {
            new ReaderThread(sharedResource),
            new WriterThread(sharedResource),
            new ReaderThread(sharedResource)
        };

        for (Thread t : threads) {
            t.start();
        }

        for (Thread t : threads) {
            try {
                t.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        System.out.println("All threads have finished execution.");
    }
}
