Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0347279C2
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Jun 2023 10:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjFHINs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Jun 2023 04:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbjFHINq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 04:13:46 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565052695
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 01:13:45 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f9baa69682so3185691cf.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jun 2023 01:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686212024; x=1688804024;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbaIqMhTyBlP+H/o9vK9rcWWIfw7JgQWtWe7dUSbLxo=;
        b=pXCxgHJ1A9UyMMVEVde9fI8gqLjaEqWs9lSkR0sENdNK7By0LL2xO3YgoHJQ/LY0nc
         xZwHWQTVhK7iTQDaSplMRqw2zbRm2srN+HYFT95qNTEqe++x2iZJt9Dcur0VMzEsNK2v
         ZS8JgkX0IS1xhNeirvBQcSpkq0qU7O/GIJeMSVQQm66/KMD9VZRajsCj4uY7nddTY32n
         EeQhdj77LLpsjcDG4nanqc4DpvLZvftI7NLpfi7XeR+LSIeVrDkBuYEKE+xFjbFEtZlX
         XIOFCErNBpo7nFxQnt39UrxQzGTaEkbifRU9prRP3JIbkTbxGpG4N/ZAC7OgNLBVz4E1
         N4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686212024; x=1688804024;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbaIqMhTyBlP+H/o9vK9rcWWIfw7JgQWtWe7dUSbLxo=;
        b=WrsE5i7ypVLNDsxdyhQ/NnW7rzts6wXNIiFE8H5OIVFV+YfndQMiwHE5Xt/PcQkugL
         cTliZaRQ1xJ3SZHzZfhFI8cRuXBiNjLuNuxSXRLFnL8w15hjcgp3Nbd+eRZwmSzaJthw
         btlmbLU0dDJ/lSmcsTjSv7eBnq1C2cb7HxfTc4uvxWZHh+ubYx5uTmDdRx7itM9yGQaP
         s0KcQnxD52IXbBn/LSro3tqikp8EzsYf0Vu5vjW1+yKvuqk8b45XL2jrc68VWB5R5Coe
         wXehDQ2BHKVgVdN4rqVXZGfXgxgwtOClGsWIaJg1IIqthLiiAk233PaghIT/wLzDpuGi
         Is1g==
X-Gm-Message-State: AC+VfDzfwgP+tn70Ihbe0bQpBW4NNBGXQ2SIYc9aKoJaHjdQ9UP74xX7
        jQrBUbSBiqbuFVkIzsSNc6yELtk4rVtaZ6LEkaa7tnqcWmU=
X-Google-Smtp-Source: ACHHUZ7QqcZCeXdPQsfsYu2hu3ZXebrNtoHT+drCWTchC7+Rdtc5PHGbwTi9DCml83+bHoUnZCoo0Xi73UkjzfUf7no=
X-Received: by 2002:a05:622a:3cc:b0:3f5:31c9:2578 with SMTP id
 k12-20020a05622a03cc00b003f531c92578mr5800993qtx.67.1686212024171; Thu, 08
 Jun 2023 01:13:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEZqKKdQ9EhRobSmq0sV76arfpk6m5XqA-=XQP_M3VRG=M-eg@mail.gmail.com>
In-Reply-To: <CAKEZqKKdQ9EhRobSmq0sV76arfpk6m5XqA-=XQP_M3VRG=M-eg@mail.gmail.com>
Reply-To: chenlei0x@gmail.com
From:   chenlei0x <losemyheaven@gmail.com>
Date:   Thu, 8 Jun 2023 16:13:32 +0800
Message-ID: <CAKEZqKKJunBVQHfTSqfs7awx1+dWhjAo4_8BtQ48R8rQ_Z6xtA@mail.gmail.com>
Subject: Re:
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

unsubscribe linux-xfs

On Thu, Jun 8, 2023 at 4:11=E2=80=AFPM chenlei0x <losemyheaven@gmail.com> w=
rote:
>
> unsubscribe
