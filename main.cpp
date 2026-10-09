#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

// A custom structure to track the download progress
struct ProgressData {
    int total_bytes;
    int downloaded_bytes;
};

// Callback function to write the incoming stream directly to the PS4 Hard Drive
size_t write_to_ps4_storage(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    return fwrite(ptr, size, nmemb, stream);
}

// Function to handle the raw web download
int download_file(const char* url, const char* destination_path) {
    CURL *curl;
    FILE *fp;
    CURLcode res;

    curl = curl_easy_init();
    if (curl) {
        // Open the designated PS4 temporary storage directory
        fp = fopen(destination_path, "wb");
        if (!fp) {
            printf("[ERROR] Cannot access PS4 partition space.\n");
            return -1;
        }

        // Set up the cURL network properties
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_to_ps4_storage);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
        
        // Optional: Bypass strict SSL if loading from old HTTP local instances
        curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);

        printf("[INFO] Pinging URL... Initiating Direct Download.\n");
        res = curl_easy_perform(curl);
        
        // Always close stream buffers and clean memory allocations
        fclose(fp);
        curl_easy_cleanup(curl);

        if(res == CURLE_OK) {
            printf("[SUCCESS] Download complete.\n");
            return 0;
        } else {
            printf("[ERROR] cURL Download failed: %s\n", curl_easy_strerror(res));
        }
    }
    return -1;
}

int main() {
    // In a fully built app, this URL string is dynamically populated 
    // by reading the PS4's OS On-Screen Keyboard input buffer.
    const char* user_entered_url = "http://example-server.com"; 
    const char* internal_ps4_destination = "/data/downloads/direct_download.pkg";

    printf("--- PS4 Local URL Package Receiver ---\n");

    int status = download_file(user_entered_url, internal_ps4_destination);

    if (status == 0) {
        printf("[INFO] Triggering local PS4 Package Installation Service...\n");
        // Next phase logic: Call internal Sony bgft service to mount and install the package
    }

    return 0;
}
