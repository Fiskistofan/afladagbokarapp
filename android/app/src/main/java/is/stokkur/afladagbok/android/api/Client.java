/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2022 Stokkur Software ehf.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package is.stokkur.afladagbok.android.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.lang.reflect.Modifier;
import java.util.concurrent.TimeUnit;

import is.stokkur.afladagbok.android.BuildConfig;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by annalaufey on 11/27/17.
 */

public class Client {

    private static Client clientInstance;
    private ClientInterface clientInterface;

    private Client() {
        Gson gson = new GsonBuilder().
                excludeFieldsWithModifiers(Modifier.TRANSIENT).
                disableHtmlEscaping().
                create();

        OkHttpClient.Builder builder = new OkHttpClient.Builder().
                addInterceptor(new FirebaseUserIdTokenInterceptor()).
                readTimeout(60, TimeUnit.SECONDS).
                connectTimeout(60, TimeUnit.SECONDS);
        if (BuildConfig.SHOW_LOG) {
            builder.addInterceptor(new HttpLoggingInterceptor().
                    setLevel(HttpLoggingInterceptor.Level.BODY));
        }
        OkHttpClient client = builder.build();

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BuildConfig.BASE_ENDPOINT)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .addCallAdapterFactory(RxErrorCallAdapterFactory.create())
                .client(client)
                .build();

        clientInterface = retrofit.create(ClientInterface.class);
    }

    public static synchronized Client sharedClient() {
        if (clientInstance == null) {
            clientInstance = new Client();
        }
        return clientInstance;
    }

    public ClientInterface getClientInterface() {
        return clientInterface;
    }

}
