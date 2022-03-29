Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE0954EB5C7
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Mar 2022 00:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbiC2WVD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Mar 2022 18:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236569AbiC2WU6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 18:20:58 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E2643395
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 15:19:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w4so26721813wrg.12
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 15:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:mime-version:content-transfer-encoding
         :content-description:subject:to:from:date:reply-to;
        bh=+v//v9bV1cKxYYqp6E5HrJfuFydY/JXcjMGnmfr7lM0=;
        b=lRSJRSYjYSBY3ACdZH/oTHdFEcrqlCy3/adKKzShctEQpDwYbP9XEU9YFmhGdltUNu
         sjyLWCU4nY//tISXz2JasDDmUasTs1kbrnBgo1ED8/hXbakmkw3k1WTNJlSQtipjGmk3
         LTRImWqT/7CkPubugr6vNw9GjPC5+vqxWXrGjNCoLVU2eIEi+2M3tGJFssxsxd0oJSOL
         uSeEK5eTpnlaOdXjHoBTST72MWrRa2LOwQJPFgLTAr+1K6oDn9c0Piyh4X1TiN56bOOx
         Zn4sTbNJX160ECi1QMMjwiHS0S9QoLqhlAk3THJy9YjCNOQfE3IzqZjvr2Pu7GH0kcvo
         SILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:content-description:subject:to:from:date
         :reply-to;
        bh=+v//v9bV1cKxYYqp6E5HrJfuFydY/JXcjMGnmfr7lM0=;
        b=Ykj0pgVEoFCfYF6ctBcojPQdiamegCa29GLDqec2fxgFpPRLXS12oHuOoC9DnmslSq
         NXyUb06LMkTQHD0CQiMZ9CPdUHWwPr5Ss6L54/RcSb0vIbDfRJjb9LYtENhBlZlHAMgE
         ThCPJngOLaW4WeA3bmt8Py468AVKGW4Pq1/gVKnuVQaLdyw5/gX+jjVGnUVKd0J8XyNt
         TmL7oHh9XdgfnFfGRqbWJNTBaxZajcShENaTfV0IFmSo5q3uDdIt7fMPmVeMPCSWV9xB
         yu1GakMtdVAWIdnAFyoXxUxcFcA6K8Tz6usBjlVFx3ETdSwibpByp4mQFA65w/E5grHI
         qS9g==
X-Gm-Message-State: AOAM533BVMX+cqsYQ8mF3n3APMH4930uh//WD+1EfPIjElJblvV1tft6
        cmyCnCY1H1sIsXxD2KJLykQ=
X-Google-Smtp-Source: ABdhPJz5xO7gOjNo25C2dUKNXGDSKS60TokWaE91bixpSse/XnlILenSGsONqsE0JEIg/Cnr/xVpgg==
X-Received: by 2002:adf:dd87:0:b0:203:da78:2802 with SMTP id x7-20020adfdd87000000b00203da782802mr33440806wrl.302.1648592353551;
        Tue, 29 Mar 2022 15:19:13 -0700 (PDT)
Received: from [172.20.10.4] ([197.210.71.189])
        by smtp.gmail.com with ESMTPSA id g1-20020a1c4e01000000b003899c8053e1sm4263738wmh.41.2022.03.29.15.19.05
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 29 Mar 2022 15:19:09 -0700 (PDT)
Message-ID: <624385dd.1c69fb81.dae14.1f49@mx.google.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Gefeliciteerd, er is geld aan je gedoneerd
To:     Recipients <adeboyejofolashade55@gmail.com>
From:   adeboyejofolashade55@gmail.com
Date:   Tue, 29 Mar 2022 23:19:01 +0100
Reply-To: mike.weirsky.foundation003@gmail.com
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_US_DOLLARS_3
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Beste begunstigde,

 Je hebt een liefdadigheidsdonatie van ($ 10.000.000,00) van Mr. Mike Weirs=
ky, een winnaar van een powerball-jackpotloterij van $ 273 miljoen.  Ik don=
eer aan 5 willekeurige personen als je deze e-mail ontvangt, dan is je e-ma=
il geselecteerd na een spin-ball. Ik heb vrijwillig besloten om het bedrag =
van $ 10 miljoen USD aan jou te doneren als een van de geselecteerde 5, om =
mijn winst te verifi=EBren
 =

  Vriendelijk antwoord op: mike.weirsky.foundation003@gmail.com
 Voor uw claim.
