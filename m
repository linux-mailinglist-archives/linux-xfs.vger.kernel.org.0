Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D680310F88
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Feb 2021 19:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhBEQZi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Feb 2021 11:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhBEQXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Feb 2021 11:23:34 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81995C06178A
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 10:05:16 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id t142so4546977wmt.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Feb 2021 10:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P600uqHJCEN9ATilhvtzyCmd2fL+4331TVKLXFIhroY=;
        b=B+tDrd36UYxa57cHnhcwzYkn4jpc1+kRl5+eJH6uOyvecq/4/yLNJpGWpTX86tA1eA
         qGfqihoQMLZ4roX8i0F+QP15UxpQxd89Nu8t53HLtOUYAm9Nx2Tx2sk1b37dde2FB7xm
         WfObHVZAtwkbFXg3NcBN3r/rxT5ubyG/LNV3Vu7psh5Mt6rigtToP4WcNlLfph15B399
         s8F/64yAnNfx8ARco0DBfIkR/n5vf2SSyhONeSqf/GVMgIQC+s8Ges4b8/iVz9UFPbNq
         8Bxuk85ZuXph7SrwKJbyzREZgusePkZxYMzGV0i9hAsPNp5de/EenxyzszsvpNbIqS6G
         hTWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P600uqHJCEN9ATilhvtzyCmd2fL+4331TVKLXFIhroY=;
        b=J98yBd4plot+2F5uryNq/Gwpdswo6YwvXL842va/lq+tz7Vv9YXmNI6x44RI73k5Ca
         XeqVrYuTEO88gPjisMz9UAzgJIsr2QvaDb1k+vItvxBoCrNMT4KudMuXYtYfry1ck9bh
         RLS4v772rfL2NXUYL+Q0809UcxZdkpALzlz5ObXy6ZcX2/1a5NX+qP0GhdzcxG9Jq8O5
         j6wrT6kTz3jDO0uWDPbPM6GvsZwnJ9DFaoivvA45qpKXXssbmXZBwgIH6GhHQDKhQkc3
         7IwlGpW2YDBBcSGN7pq7ht7mWT93veSBevmJvB8bYRVfJLxWgNtgXr4w/qIqUEvPklha
         V+PQ==
X-Gm-Message-State: AOAM530apyAXiDnrrx11s5LPUN0RjEiZs/MhR3MvFRgmi/yC8yxISAHb
        fH0tHlZiuwqmcsqOg2wDHq2gbfDhX0BWoV3w
X-Google-Smtp-Source: ABdhPJzNX6YzcSJ9hHRHmaBOZ5VY6fEnYPkHo6uygIvIhxMajymd5epGOeFwY3JeQxNwisYcdH4ufg==
X-Received: by 2002:a7b:c842:: with SMTP id c2mr4601319wml.100.1612548315301;
        Fri, 05 Feb 2021 10:05:15 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id n187sm9491830wmf.29.2021.02.05.10.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 10:05:14 -0800 (PST)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210205003125.24463-1-bastiangermann@fishpost.de>
 <20210205003125.24463-2-bastiangermann@fishpost.de>
 <20210205005100.GK7193@magnolia>
From:   Bastian Germann <bastiangermann@fishpost.de>
Subject: Re: [PATCH 1/3] debian: Drop unused dh-python from Build-Depends
Message-ID: <ca46724d-dce6-ac8c-65a7-99beb6bfc27c@fishpost.de>
Date:   Fri, 5 Feb 2021 19:05:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205005100.GK7193@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am 05.02.21 um 01:51 schrieb Darrick J. Wong:
> On Fri, Feb 05, 2021 at 01:31:23AM +0100, Bastian Germann wrote:
>> xfsprogs participates in dependency loops relevant to architecture
>> bootstrap. Identifying easily droppable dependencies, it was found
>> that xfsprogs does not use dh-python in any way.
> 
> scrub/xfs_scrub_all.in and tools/xfsbuflock.py are the only python
> scripts in xfsprogs.  We ship the first one as-is in the xfsprogs
> package and we don't ship the second one at all (it's a debugger tool).
> 
> AFAICT neither of them really use dh-python, right?

That is right. dh-python is generally used at build time to generate 
packages with Python modules, i.e., with files in 
/usr/lib/python3/dist-packages. That is not the case in xfsprogs.

For xfsprogs, python3 is only a runtime dependency and that is defined 
in the control file as well.

> --D
> 
>>
>> Reported-by: Helmut Grohne <helmut@subdivi.de>
>> Signed-off-by: Bastian Germann <bastiangermann@fishpost.de>
