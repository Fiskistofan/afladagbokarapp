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

import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;

import javax.annotation.Nullable;

import io.reactivex.Observable;
import io.reactivex.annotations.NonNull;
import io.reactivex.functions.Function;
import is.stokkur.afladagbok.android.AfladagbokApplication;
import retrofit2.Call;
import retrofit2.CallAdapter;
import retrofit2.HttpException;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;

/**
 * Created by annalaufey on 2/19/18.
 */

public final class RxErrorCallAdapterFactory extends CallAdapter.Factory {

    private final RxJava2CallAdapterFactory originalCallAdapterFactory;

    private RxErrorCallAdapterFactory() {
        this.originalCallAdapterFactory = RxJava2CallAdapterFactory.create();
    }

    public static CallAdapter.Factory create() {
        return new RxErrorCallAdapterFactory();
    }

    @SuppressWarnings("unchecked")
    @Nullable
    @Override
    public CallAdapter<?, ?> get(Type returnType, Annotation[] annotations, Retrofit retrofit) {
        return new RxCallAdapterWrapper(retrofit,
                originalCallAdapterFactory.get(returnType, annotations, retrofit));
    }

    private static class RxCallAdapterWrapper<R> implements CallAdapter<R, Observable<R>> {

        private final Retrofit retrofit;
        private final CallAdapter<R, Observable<R>> wrapped;

        public RxCallAdapterWrapper(Retrofit retrofit, CallAdapter<R, Observable<R>> wrapped) {
            this.retrofit = retrofit;
            this.wrapped = wrapped;
        }

        @Override
        public Type responseType() {
            return wrapped.responseType();
        }

        @SuppressWarnings("unchecked")
        @Override
        public Observable<R> adapt(@NonNull Call call) {
            return wrapped.adapt(call).
                    doOnNext(next -> {
                        if (next instanceof Response) {
                            Response response = (Response) next;
                            // TODO: create some http codes handling
                            if (response.code() == 204) {
                                // Do something
                            }
                            if (response.code() == 500) {
                                throw new HttpException(response);
                            }
                        }
                    })
                    .onErrorResumeNext(new Function<Throwable, Observable>() {
                        @Override
                        public Observable apply(@NonNull Throwable throwable) throws Exception {
                            return Observable.error(asRetrofitException(throwable));
                        }
                    });
        }

        private RetrofitException asRetrofitException(Throwable throwable) {
            // We had non-200 http error
            if (throwable instanceof HttpException) {
                HttpException httpException = (HttpException) throwable;
                Response response = httpException.response();
                if (response.code() != 500) {
                    return RetrofitException.customError(response.raw().request().url().toString(),
                            response, retrofit);
                }
            } else if (throwable instanceof IOException) {
                return RetrofitException.unexpectedError(
                        new Throwable(AfladagbokApplication.getAppContext().
                                getString(is.stokkur.afladagbok.android.R.string.no_internet_error)));
            }
            return RetrofitException.unexpectedError(
                    new Throwable(AfladagbokApplication.getAppContext().
                            getString(is.stokkur.afladagbok.android.R.string.general_error)));
        }
    }

}