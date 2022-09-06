Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7035AEDAD
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Sep 2022 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbiIFOnR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Sep 2022 10:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbiIFOms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Sep 2022 10:42:48 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0823E9D13A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Sep 2022 07:03:04 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 202so12288616ybe.13
        for <linux-xfs@vger.kernel.org>; Tue, 06 Sep 2022 07:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uc-cl.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=M3kjx4Y3PDh1LmA6EIlHrLnuQj4q0vHuaf8i2Q6glTw=;
        b=E+Z3tYiaqqhX3ewT9tjNYatrnxaV+r5W3vhI+RR+uWIACl04L1Bnui04nEJiwFbtNS
         A7ZyWXUJQYUyw2yM5TCqv2a6FalBMQWKGxgK6qvMoDmWkm6PLGaqnNW6lq0M1bv1Q1oT
         Knwy2Dpb8kvbwKRZfBBtQ4avSTLI9CT4oOXc18orUnZsHOXeYL0QOTH7vYy8jFPnZ3Rg
         AkSvX/xhsGseBY3N/tzZq42+x/5mccsFlHIKbmtyqmRnannfHJMEgVm3ik0KaHqVuxwc
         woIzHHFXOf1k6+vbdXFkqUQqBbDK2hRWYXnJ3bFX/BgvB+/IzGuFJfoi8L16g3R6clPx
         VHAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=M3kjx4Y3PDh1LmA6EIlHrLnuQj4q0vHuaf8i2Q6glTw=;
        b=r02BjDt7NhUImVxDA/OX1ZQEJLKa3iBav/85I75Nqllqv+8EhWzqcf71neSV90lCOp
         4f2vtdj1jfb0YlW11z0kfeq05en2hxs9pI7DXGWZpma7EfsF/TOMOtzRfcxTw2AnqJsf
         YU1Kopz3iWF+mpNsrc2ePy8qGCV8MtkHwkCadlBCpN8tQtDcpPBxz5Kzo3qaMw14k7KX
         gwXfRwqrGeMQr6cukY1FJ2mWtCBTcMmqom3UaeIwQ8VaYodRWN9H1mfiS9iC1pgjt8Es
         4G0msSbfKwLQzXBEQNprclAVUJK0ETQFO4wDYjwhv2YhoWugaPrdEYPLeUd9G82GtlO8
         756g==
X-Gm-Message-State: ACgBeo2zqf5KGLKkcxWB7xfssZdWb7R2jSq6+g+ap6MFkNDihsMRl6oc
        KqlBfUMfaxkqn4zncf7bo2ajFC3hwCnLDmao5Lkt7y626vRdHqGdrOQtMOhn2+vkXmZu96FUtBC
        uEy2OUczefpfJ1AQ1EfiDvbPE2OeD
X-Google-Smtp-Source: AA6agR5iI7iiC6XVQ5DaFgLzs5oiIgbdXb7Kp07/cMkWkUlNo51TtvCATi3eLomt58iPLOK6p3+f/xgp5OmNHq+GsYA=
X-Received: by 2002:a25:9d01:0:b0:66e:9087:4fb9 with SMTP id
 i1-20020a259d01000000b0066e90874fb9mr38589554ybp.159.1662472911309; Tue, 06
 Sep 2022 07:01:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a25:db8b:0:0:0:0:0 with HTTP; Tue, 6 Sep 2022 07:01:50 -0700 (PDT)
Reply-To: veronica_suecharlottefoundation@outlook.com
From:   Veronica Sue Charlotte Foundation <pgarciacan@uc.cl>
Date:   Tue, 6 Sep 2022 22:01:50 +0800
Message-ID: <CAFvnNwa6s+2ffWoJM8p_7psgOCiYsE_jmffQtS7+Zmvtot4HFA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.2 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FORGED_REPLYTO,HK_LOTTO,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b41 listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.8674]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.0 HK_LOTTO No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--=20
Dear Email Owner Kindly confirm ownership of your email. It was
randomly selected after a computer draw, to receive a donation of
$1,700,000.00 USD from Veronica Sue Charlotte Foundation. Send a
confirmation Email for more details.

--=20
No sienta la obligaci=C3=B3n de contestar este mail fuera de horario labora=
l.
