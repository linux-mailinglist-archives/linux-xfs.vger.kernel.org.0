Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C59852C72D
	for <lists+linux-xfs@lfdr.de>; Thu, 19 May 2022 01:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiERW6d (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 May 2022 18:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiERW6I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 18:58:08 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EAA17DDEB
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 15:57:12 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2ff1ed64f82so40458477b3.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 15:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=czYkjWVoP4p/ZkNBJUSmJBfxUUt+Y13DbrrHvBfDUk39swnu2r1R2LMB3wAsUSY8FJ
         6ZHix6GZx2AHI61Xybet6sdcQlFElibcif9NAvmWTzz0l58WRUD1Pr+/0udl5Tub4w6J
         meMNyRnYfYgN6d8AQA50exC5S8Br4+BjGl3igVF9bo6vnyZ0caprRk+RWxvnLby0Adqm
         hPjkVM8mttTA162cBcx8kN6mr4q9cNJsYcLYU7yQFFkOaGBf3QJSI1TLD1TTjQK6bKO2
         /uQaa7XB0ntetoq2a8c8ZgimsW4075bFpPpigSla9RqML/vkCGJpD6xavnQrqxd781aK
         ZwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=mZ3wqB4NmL7z6lpFr/h15h1rYqsZKafJnUpMVahbEPg=;
        b=psANjpRtq73lx+hJuLeFnvkQ0WRfhKlZfYxvMLtn/WohzkcQCyCgQ5IWaOOrrEa7PR
         IdVmtuC8BUhV3LX7m0llG/ftceVPzUJYt4STDrb9GP2i1cuiaDC4g7osrRGmAUjXwkBG
         OjjtmSJXv+mPuPQSACVy5TPVdWBdUrLdP4PAElx3AxJ9a3lAXEWk1F9lEs84w92rA8Nc
         GmK0wmz/EUzZeOyR4RT+1hHz9reTXCRoFa6GhnIHukKnZYvGBS6OZXIzORrAOaRez1Xi
         dCATRQAnJfuUhnK/zql+gNbYyMjjdPdF9j7/sf0jhtYFGaGqksQ4Srf9BjgpDPcPNU5a
         2w3g==
X-Gm-Message-State: AOAM531BRBt/bXrz/i6cxqsJ59Nb6FbjZJPxNnf+mURXNncm0N7A9yCU
        Xdx/jXUHjYsgazPMxrF5UStAkSej/TBvmXYPVpw=
X-Google-Smtp-Source: ABdhPJwfS30wbsCjPY8UVYlWs7ui3rJia0tAtpKvKb7UJ9kvW7xj8JsSqbuzt2V828J/37SMn7X7nS55vBF2Wrce63I=
X-Received: by 2002:a0d:ccc3:0:b0:2ff:4e0:2be5 with SMTP id
 o186-20020a0dccc3000000b002ff04e02be5mr1833971ywd.225.1652914631436; Wed, 18
 May 2022 15:57:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:7143:0:0:0:0 with HTTP; Wed, 18 May 2022 15:57:11
 -0700 (PDT)
Reply-To: tonywenn@asia.com
From:   Tony Wen <weboutloock4@gmail.com>
Date:   Thu, 19 May 2022 06:57:11 +0800
Message-ID: <CAE2_YrAOSJNMn2masB_R9LowQvWJNrct3SYBUk3PivGhjD0fCA@mail.gmail.com>
Subject: engage
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Can I engage your services?
