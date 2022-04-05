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

import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.Tasks;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.GetTokenResult;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

/**
 * Created by annalaufey on 1/25/18.
 */


public class FirebaseUserIdTokenInterceptor implements Interceptor {

    // Custom header for passing ID token in request.
    private static final String X_FIREBASE_ID_TOKEN = "Authorization";

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request request = chain.request();

        try {
            FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();
            if (user == null) {
                throw new Exception("User is not logged in.");
            } else {
                Task<GetTokenResult> task = user.getIdToken(false);
                GetTokenResult tokenResult = Tasks.await(task, 30L, TimeUnit.SECONDS);
                String idToken = tokenResult.getToken();

                if (idToken == null) {
                    throw new Exception("idToken is null");
                } else {
                    Request modifiedRequest = request.newBuilder()
                            .addHeader(X_FIREBASE_ID_TOKEN, "Bearer " + idToken)
                            .addHeader("Content-Type", "application/json")
                            .build();
                    return chain.proceed(modifiedRequest);
                }
            }
        } catch (Exception e) {
            throw new IOException(e.getMessage());
        }
    }

}
