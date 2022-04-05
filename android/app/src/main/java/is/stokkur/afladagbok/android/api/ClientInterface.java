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


import java.util.ArrayList;

import io.reactivex.Observable;
import is.stokkur.afladagbok.android.models.ConfirmTourResponse;
import is.stokkur.afladagbok.android.models.ProfileResponse;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchBody;
import is.stokkur.afladagbok.android.models.RegisterAnimalCatchResponse;
import is.stokkur.afladagbok.android.models.RegisterFishCatchBody;
import is.stokkur.afladagbok.android.models.RegisterFishCatchResponse;
import is.stokkur.afladagbok.android.models.RegisterPullBody;
import is.stokkur.afladagbok.android.models.RegisterPullResponse;
import is.stokkur.afladagbok.android.models.RegisterTossBody;
import is.stokkur.afladagbok.android.models.RegisterTossResponse;
import is.stokkur.afladagbok.android.models.RestrictedZone;
import is.stokkur.afladagbok.android.models.StartTourBody;
import is.stokkur.afladagbok.android.models.StartTourResponse;
import is.stokkur.afladagbok.android.models.StatisticHistoryResponse;
import is.stokkur.afladagbok.android.models.StatisticResponse;
import is.stokkur.afladagbok.android.models.StatisticsDetailResponse;
import is.stokkur.afladagbok.android.terms.AcceptTermsResponse;
import is.stokkur.afladagbok.android.terms.PrivacyTermsResponse;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;

/**
 * Created by annalaufey on 11/27/17.
 */

public interface ClientInterface {

    @GET("v1/profiles/me")
    Observable<ProfileResponse> getUserInfo();

    @GET("v1/statistics")
    Observable<StatisticResponse> getStatisticsByDate(@Query("dateFrom") String dateFrom,
                                                      @Query("dateTo") String dateTo,
                                                      @Query("shipId") String shipId);

    @GET("v1/history")
    Observable<StatisticHistoryResponse> getStatisticHistory(@Query("page") int page,
                                                             @Query("size") int size,
                                                             @Query("shipId") String shipId);

    @GET("v1/tours/{tourid}/history")
    Observable<StatisticsDetailResponse> getStatisticDetail(@Path("tourid") int tourId);

    @POST("v1/tours")
    Observable<StartTourResponse> startTour(@Body StartTourBody startTourBody);

    @PUT("v1/tours/{tourid}/toss/{tossId}")
    Observable<RegisterTossResponse> registerToss(@Path("tourid") int tourId,
                                                  @Path("tossId") String tossId,
                                                  @Body RegisterTossBody registerTossBody);

    @PUT("v1/tours/{tourid}/pull/{pullId}")
    Observable<RegisterPullResponse> registerPull(@Path("tourid") int tourId,
                                                  @Path("pullId") String pullId,
                                                  @Body RegisterPullBody registerPullBody);

    @PUT("v1/tours/{tourId}/catch/{catchId}")
    Observable<RegisterFishCatchResponse> registerCaughtFish(@Path("tourId") int tourId,
                                                             @Path("catchId") String catchId,
                                                             @Body RegisterFishCatchBody registerCatchBody);

    @PUT("v1/tours/{tourId}/catchMammalsAndBirds/{orderSpeciesCatchId}")
    Observable<RegisterAnimalCatchResponse> registerCaughtAnimals(@Path("tourId") int tourId,
                                                                  @Path("orderSpeciesCatchId") String orderSpeciesCatchId,
                                                                  @Body RegisterAnimalCatchBody registerCatchBody);

    @POST("v1/tours/{tourId}/confirm")
    Observable<ConfirmTourResponse> confirmTour(@Path("tourId") int tourId);

    @GET("v1/restrictedZones")
    Observable<ArrayList<RestrictedZone>> getRestrictedZones(@Query("date") String date);

    @GET("v1/terms")
    Observable<PrivacyTermsResponse> checkForTerms();

    @GET("v1/terms/{termsId}/accept")
    Observable<AcceptTermsResponse> acceptTerms(@Path("termsId") long termsId);

}
