Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB3E36D3BE
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Jul 2019 20:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390368AbfGRSTs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 18 Jul 2019 14:19:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44702 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfGRSTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 14:19:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id k18so28281573ljc.11
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 11:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gepmqZ8N/IE1dD9ivKS4WqYoEjZkViTT4tcrJbEnbOk=;
        b=hz94MbDILZQNajQa2trZ7qSP+dksrJ1mAn7+S56JhO9w6m2RoO+0OT5YlB/RoWVZsm
         b6VzRDPrYK6DWpUJo2nniO3XvejJMPKKxgv6OvnMr/AqDX/Q+A97QqUJ3nnZY+EcO0B5
         fNB3N40k3vyszAKIDXrJNNSSZ9MG6v37aATJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gepmqZ8N/IE1dD9ivKS4WqYoEjZkViTT4tcrJbEnbOk=;
        b=Zw/UMTkSI7QpX4Nrq7NxxLgotNa8aXvnnFUIhMxNq7KWC1rci94xPZtImOAgIiSutp
         Zq+F2dxYVvUU1Dz3sJWXeSlbz5SWgE25I+u6FPrAhYnEDqws++i1sFCe3V4Tw8tTXA0+
         EmwzFhc5El7Z+9uTKzFY4OFePDZQMLJHQLmYHblKlmAVLj7VA3rp7C1zgZQQ5moKAWbD
         tFr2LmLpeKfiRYeRTCyRlHMLPNS6W0ajm4ZM3MNdYBBhC6MpLxQzGmwgRF5TmxFy2Z/v
         tgn27nDjVI8R4GXsXEQZR3s/RMcT1bGcjlVimDXsRQGSw0KGgs4foqtP4mWJlw/w3xX5
         IG7w==
X-Gm-Message-State: APjAAAXC5AcWitM1bqOaM600CQDGRNTQMQrN/lHwc+6xl+tqy6I56UKf
        80f/ezVO3AjCXJURlnx45QO491PTq1o=
X-Google-Smtp-Source: APXvYqyiqm0AsfbJvn9odXofWfWuG57vEjfUC6pAkZynfRXbUdhXU5Z1Pbrmi+CclZvBS7KYlYWNRQ==
X-Received: by 2002:a2e:9593:: with SMTP id w19mr9389878ljh.69.1563473986063;
        Thu, 18 Jul 2019 11:19:46 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id r68sm4105691lff.52.2019.07.18.11.19.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 11:19:45 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id x3so19980200lfc.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 11:19:44 -0700 (PDT)
X-Received: by 2002:ac2:4839:: with SMTP id 25mr21790208lft.79.1563473984522;
 Thu, 18 Jul 2019 11:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190718161824.GE7093@magnolia>
In-Reply-To: <20190718161824.GE7093@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 18 Jul 2019 11:19:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whewBiKzpsO73Y38SAPSktxD6gUuEr2ANC8Z_3JPiqk3w@mail.gmail.com>
Message-ID: <CAHk-=whewBiKzpsO73Y38SAPSktxD6gUuEr2ANC8Z_3JPiqk3w@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: cleanups for 5.3
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 18, 2019 at 9:18 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Please let me know if you run into anything weird, I promise I drank two
> cups of coffee this time around. :)

Apparently two cups is just the right amount.

                 Linus
