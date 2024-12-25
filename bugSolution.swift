enum APIError: Error {
    case networkError
    case badResponse
    case dataError
}

func fetchData() async throws -> Data {
    let url = URL(string: "https://api.example.com/data")!
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.badResponse
        }
        return data
    } catch let error as URLError {
        throw APIError.networkError
    } catch {
        throw APIError.dataError
    }
}

Task { 
    do {
        let data = try await fetchData()
        // Process data
    } catch let error {
        switch error {
        case APIError.networkError: 
            print("Network Error")
            // Handle network error, e.g., show an alert, retry
        case APIError.badResponse: 
            print("Bad Response")
            // Handle bad response, e.g., show an error message
        case APIError.dataError:
            print("Data error")
            //Handle data error, e.g., show a message indicating data processing failure
        default: 
            print("An unexpected error occurred: \(error)")
        }
    }
}