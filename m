Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD32A10783
	for <lists+linux-xfs@lfdr.de>; Wed,  1 May 2019 13:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfEALeC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 May 2019 07:34:02 -0400
Received: from mail-yw1-f52.google.com ([209.85.161.52]:44172 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfEALeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 May 2019 07:34:02 -0400
Received: by mail-yw1-f52.google.com with SMTP id j4so8080772ywk.11
        for <linux-xfs@vger.kernel.org>; Wed, 01 May 2019 04:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Pl3cNjPavHv9GNC4RivEwWnbNQMYfNgEzh+tOrF/qUg=;
        b=oqhx8ot0GQ4gVRf90X1RblylCwP3M5+zopYzpEvmqaM+xKu6p0YHU2uoXAUvPKRENe
         phEhOo02RJ0MuIMRIGj6J91rbUfO24qbDm4ovo4TUvS7zlW53JP5VqPg4NMr9EJW7Ofg
         yAgA8l8XZU1KmwZ7fmZgCGM4EO3QEIX7TWO8zQ5vA2GpDKHWafS1fIxCNg9tZHxuAwZr
         tdndqq6fxQWIvxilfmlv01Dxwen476UJsguRn8R5ttQ9ZEl82IoZ/+nitSPZB7/C4JvU
         g2TtdSV1h5qOReFbAx3N2Yfl+Fs+lDguaBsHY62y6tk2IbL+U/AeOib8jSOH/15pXlWj
         aouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Pl3cNjPavHv9GNC4RivEwWnbNQMYfNgEzh+tOrF/qUg=;
        b=trDO0ZGmh/+qxKRGBqjghbN2G2CIGwZmMMYlbnGYr/HRPjZoNy8xk+Xp3jkaMjIRf9
         0tZ4LyBEYzwfeN4f6amT80/1RYnCbzCbxqqI+IxRa+XnPmqz+9pep2nMUqJhyWmealID
         f44bcbdbnMwUdnZf6sdcdhsohZ4S0ECKt3UJME5dg/sL57P+WRvD+AvZDU8fkp90pWbD
         1eAPYQELaVQRWlGH9g5IJ8lbKizrsclMw4LWLjzSuxADLFQAEa4bdIgNtUOyi/Ytc4Pv
         Xn5mzY0i6S619mHeS6egQqx34X7wLKUS/iYkxLlwhy4ejsoIeWaBWzcfLMhJvx2i7qHX
         jrGQ==
X-Gm-Message-State: APjAAAWV2RpYc1y3dusjlulK4x4aX205NfposswV3oOQwVvIMNDRY0ap
        0/M1Jg+XGWwaVFjni6LQqMKP1uEj6CFdHXmLjoyLP2TU
X-Google-Smtp-Source: APXvYqw30hz9mFM1sMl6brjT+LHGYE8kPZ8Lcm92W8DpnH3lM1frhIjWShpG/Luy1LNXklYii/vBywaudmjjgyuPkaw=
X-Received: by 2002:a81:5294:: with SMTP id g142mr53293112ywb.211.1556710441760;
 Wed, 01 May 2019 04:34:01 -0700 (PDT)
MIME-Version: 1.0
References: <RT-Ticket-61233@linuxfoundation> <20180923010246.GB4590@magnolia> <rt-4.4.0-14016-1537793643-303.61233-6-0@linuxfoundation>
In-Reply-To: <rt-4.4.0-14016-1537793643-303.61233-6-0@linuxfoundation>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 1 May 2019 07:33:50 -0400
Message-ID: <CAOQ4uxiMTQB3joKNj7gJs+TEo4Ru+tGVbYtN1twkonTC7+WU8A@mail.gmail.com>
Subject: Re: [Kernel.org Helpdesk #61233] Please add linux-xfs@vger.kernel.org
 to lore.kernel.org
To:     kernel-helpdesk@rt.linuxfoundation.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 24, 2018 at 9:03 AM Konstantin Ryabitsev via RT
<kernel-helpdesk@rt.linuxfoundation.org> wrote:
>
> On 2018-09-22 21:02:50, darrick.wong@oracle.com wrote:
> > Hi, it would be great if you could start archiving the
> > linux-xfs@vger.kernel.org mailing list on lore.kernel.org.
>
> The agent has been subscribed to the list. Please proceed with archive collection.
>

Darrick,

Do you know what's holding that process back?

Thanks,
Amir.
