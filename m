Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE1043EDE
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 17:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732759AbfFMPxc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 11:53:32 -0400
Received: from mail-yw1-f43.google.com ([209.85.161.43]:36409 "EHLO
        mail-yw1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731610AbfFMJCW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 05:02:22 -0400
Received: by mail-yw1-f43.google.com with SMTP id t126so8039255ywf.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 02:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PY4MTSAiyfAeqQ1EoK1phEFJQeBQDmlO5b+7DPU23nU=;
        b=mndJg9KWLChGfxxzS2vb/V8s5kknc/xKZtS5CQpuL1+pAQ0eriRTinWCBCXzwu/nCy
         GAUW9C8ZvRIeb6XrV4OFvOC1uGCI7ZnxmPraONbTUhqznblH1gF4QKGU0AdI3l2om7Yj
         vjLI9JqcFFnkOhqQKacQPS2xQzbVIPoTTitBr0M2MLgCMQaN052vxyK7bDpaLkPdxLiI
         YansDbXptNh5xhiZg4sE/yRLOAE09Zf35/vW1Y/96g+MDdGfk4qgYYn8XoPF8+te6MLq
         TGJarpu5v3OPPJq66fIvXuBye9g+TsyLzGO2wrb3TH0eGXacL1de9psKSspngX914DmL
         roJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PY4MTSAiyfAeqQ1EoK1phEFJQeBQDmlO5b+7DPU23nU=;
        b=Ile1xzDLQO6Q8iXZiE8OjyIVOtG1P2/sUeIyiTf6VazUjo6I/0q3PA8zInm267wiGq
         gZ6R+c6qjagFsgpaXvcugsoeyelAfruoyBnTuIPy96ZIctq2gWxRyOwhEv6REdLdqvvn
         cRP0IAjC2FvT+zjps+O0qE9WMzcZ0b5G4+wlryoD5uwgRBjYJzfSYKmtn1GemVPOkATf
         ECHOrhGQzT0PdDOCLTkDntaoagYdxBBaGBGdvTVuSLdkXGUrcheCUEcDlIaREtDa4516
         7Vo4P0Gfjc9aPln88QH9bmf5f8FAPKHdd2Sdu6BMjWnCaFMK4L9WZ6alTDCjcYN02mh5
         VIGQ==
X-Gm-Message-State: APjAAAVmJdaqa6smyJa1sgvlvlCMxXOO7muB5af2mTeQU7a0X6FbLQ92
        JPxrYEpg/ayCKhnhad/b02TwjODsRAhh+z0O
X-Google-Smtp-Source: APXvYqxHP/XueIS81D/+6MZQNXrdu9gB8OCiZ+WsU0DRJhR7X0LMQ+asZdp6O6UY4xVnjE2/v9mMYA==
X-Received: by 2002:a81:3314:: with SMTP id z20mr28158534ywz.341.1560416541330;
        Thu, 13 Jun 2019 02:02:21 -0700 (PDT)
Received: from [172.20.10.3] (mobile-166-172-57-221.mycingular.net. [166.172.57.221])
        by smtp.gmail.com with ESMTPSA id z6sm621875ywl.50.2019.06.13.02.02.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 02:02:20 -0700 (PDT)
Subject: Re: alternative take on the same page merging leak fix
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20190611151007.13625-1-hch@lst.de>
 <20190612010922.GA17522@ming.t460p> <20190612074527.GA20491@lst.de>
 <20190612101111.GA16000@ming.t460p>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5d781312-d28e-5bcc-4294-27facdd4a1e7@kernel.dk>
Date:   Thu, 13 Jun 2019 03:02:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612101111.GA16000@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/12/19 4:11 AM, Ming Lei wrote:
> On Wed, Jun 12, 2019 at 09:45:27AM +0200, Christoph Hellwig wrote:
>> On Wed, Jun 12, 2019 at 09:09:23AM +0800, Ming Lei wrote:
>>> We have to backport the fixes to -stable tree, and downstream need to
>>> ship the fix too.
>>>
>>> The issue is quite serious because the leak is in IO path and the whole
>>> system ram can be used up easily on some workloads. So I think the fix
>>> should be for 5.2, however, regression risk might be increased by
>>> pulling cleanup & re-factor in now.
>>>
>>> I really appreciate you may cook a fix-only patch for this issue.
>>> Especially the change in add pc page code isn't necessary for fixing
>>> the issue.
>>
>> Patches 3 and 4 have no dependencies on 1 and 2, and should have
>> arguably been ordered first in the series.
> 
> OK, that is good to make patch 3 &4 into 5.2, I will give a review
> soon.

I'll echo Mings sentiments here, for the series.

-- 
Jens Axboe

