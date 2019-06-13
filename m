Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D95143EA8
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 17:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389296AbfFMPvu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 11:51:50 -0400
Received: from mail-yb1-f173.google.com ([209.85.219.173]:39364 "EHLO
        mail-yb1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbfFMJLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 05:11:14 -0400
Received: by mail-yb1-f173.google.com with SMTP id y17so233758ybm.6
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 02:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hdzDaIQivM2GQQjKjPKFTqRgsbrNCZqKbK0V3ZVo6Nc=;
        b=lRIstcniXTx23F3u1CwanJ3jT9Y9GDWZBnk8ih5ZPbzLi4oLEcY1Qs/S8iTuN9JOF7
         4thioH21/1zFEFv1TsO6pKtA6GrAOCQM3xwGiRyU7A4+tAlWQP6dQ4VvCAt3eG8ooEy2
         dR/KfvZI7Zli68tEfmTyINRkXnTaL4xnuifgLztk5DUPlFl7jWVD7Mw9x1I1HPyIKMrM
         HJkhYc2O5YiFMKywVqocyM4ww4HO4dUdeN7p135MlVPVcCWUuRHDyBZUdCbDcnG0ucbU
         F4nSyTpUipCX9W7H3zENc3twMh4NDTuXkMyDATFHVwB5XNaO6PCUjKKc4uESvmcIXVGh
         JFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hdzDaIQivM2GQQjKjPKFTqRgsbrNCZqKbK0V3ZVo6Nc=;
        b=b+J/8f9OaFmGaQgdIg/ABttGdHeuql9HxKg1084FAWFwYF97ojl8ddTDN57VA5eG6y
         0MyFr1h9+7jFUwsdXzy1hyNZB9pD/8A7GtISnR4BJCN2wkiouoz+ujsAK3qOUzrEOZ93
         pO7tkp7q/JDKiRVe4yE3uD5Mfjb7phAikHvye7YZ2ayMfVECprNqYrsMAwVUWNtNfgv+
         T2geeSg4IwjGZZNLD2KUG3OESkEWmJRghdH8Cn5kyjH6JuCYdRjomchsbgD424wApbtG
         38DJlPt8MgWIo2rV0SYDY/tUG1f+vIWsvyEqd7NeCmeh3xVsF8BRB4Ouga0Hln8cJYKO
         cDVQ==
X-Gm-Message-State: APjAAAXElGxEIYgA2rY/8UQtiFWa01cmaPFtSaeOOXHaRh1WHoWF4Yjx
        MgXDvcP11epyj6c+FGx2XV60VRkekztbv54y
X-Google-Smtp-Source: APXvYqwiB1JSXJv/GplehKTd8d79Fp2Ps5UxWQYgA68H+h9FLlw/rNDhR2FPb9kv5p4VIMSMzCWuBQ==
X-Received: by 2002:a5b:44:: with SMTP id e4mr44036072ybp.257.1560417072692;
        Thu, 13 Jun 2019 02:11:12 -0700 (PDT)
Received: from [172.20.10.3] (mobile-166-172-57-221.mycingular.net. [166.172.57.221])
        by smtp.gmail.com with ESMTPSA id p128sm1040304ywp.24.2019.06.13.02.11.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 02:11:11 -0700 (PDT)
Subject: Re: alternative take on the same page merging leak fix
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20190611151007.13625-1-hch@lst.de>
 <20190612010922.GA17522@ming.t460p> <20190612074527.GA20491@lst.de>
 <20190612101111.GA16000@ming.t460p>
 <5d781312-d28e-5bcc-4294-27facdd4a1e7@kernel.dk>
 <20190613090257.GA13708@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0eb5ef0-4cb0-d2c0-7f5a-12830e916672@kernel.dk>
Date:   Thu, 13 Jun 2019 03:11:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613090257.GA13708@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/13/19 3:02 AM, Christoph Hellwig wrote:
> On Thu, Jun 13, 2019 at 03:02:10AM -0600, Jens Axboe wrote:
>>>> Patches 3 and 4 have no dependencies on 1 and 2, and should have
>>>> arguably been ordered first in the series.
>>>
>>> OK, that is good to make patch 3 &4 into 5.2, I will give a review
>>> soon.
>>
>> I'll echo Mings sentiments here, for the series.
> 
> And what does that actually mean?  Do you want me to just resend
> 3 and 4, or can you just pick them up?

Please resend them with the acks/reviews, I'll pick them up asap.

-- 
Jens Axboe

