Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB087632E94
	for <lists+linux-xfs@lfdr.de>; Mon, 21 Nov 2022 22:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiKUVPv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Nov 2022 16:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiKUVPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 16:15:51 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1342CDCB
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 13:15:50 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id t17so10832614pjo.3
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 13:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2nw4280vwj2f5WYqCk4Z9/IndXBzQTPRCYcKzRb1bHo=;
        b=J9AY8sOSW9URgz0YQ4nOO6U3ssnHWbY+4/68DOneQuYcch3UIq41LcxOITzcNQzwwI
         YnCCo5og55kuPL2EnU4q9uoD64YkJnTT/P8rhHXCMaVDhzMQcYxLTBEKn1zCyZpP41VR
         wcF7KKny/EME8YU0i1BVoeuPpuoAZ8w/huK3brrvJ0fqpdcSJK7O/10m1+CjcoKhPUkS
         tBA0pbQGkjmw+wzaZlf9ecKVZobB/JFtyD2jVCtVnNihpoeRz6BvB7m7Q93i+69UI/m4
         0vqPW3gCh1xRR2wafX722yipnlvQ+kHKf+5hPrN90hhaKLJQ0KSjsAaxRiRHlBYPthPi
         G67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2nw4280vwj2f5WYqCk4Z9/IndXBzQTPRCYcKzRb1bHo=;
        b=3+i8E93M7PkUiKJoWY2kKJr7Nz44CQJ1n7C3HGlmw8+5twSE/uluu4O4o/qMUMqZ+p
         4c2t3Ar4XzvpsYbDAK89keIQzzDiqsNWUsOfZyV6j3/dk8pxusbzE9h1U26X2gIHdI+U
         lpB3uLZcO8JRTb2ETDHHH3sKQ4NSRTtUEF1ziTletSnTrqOTFFzJ0vijiulusudMm2gn
         ObycMcrqi92ONhMmOJj4cA+8/xAdp4vRyFcsbVYbIkXCfbq6NyPEQiqP8YQv3UEV7xPc
         S/bVfURrqS+iwd971Nh+WQOLKVlqhjUJ7b7XQ7NDqekTqqhsP9uVFhBUFYosO7iBgerm
         7z3Q==
X-Gm-Message-State: ANoB5pl5vKwKTcrKPsawhJpOSODudPcxmBpP+y1Hd137FUW7/c2iYDGu
        bVCqh/gachokU9PANV3+pKKi8uzq2AwEGw==
X-Google-Smtp-Source: AA0mqf7E/nc7BcX4N50O3DeqvCS9Nfp1Edi+XWz4GgiEO2WcY8Fg9tsiCWXe2OnKngBWi/aeehq8mA==
X-Received: by 2002:a17:902:b78b:b0:186:e2c3:91c6 with SMTP id e11-20020a170902b78b00b00186e2c391c6mr1018137pls.27.1669065350224;
        Mon, 21 Nov 2022 13:15:50 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id w1-20020a1709027b8100b00181e55d02dcsm10283918pll.139.2022.11.21.13.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 13:15:49 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxE8p-00H11n-9F; Tue, 22 Nov 2022 08:15:47 +1100
Date:   Tue, 22 Nov 2022 08:15:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 0/2] porting the GETFSUUID ioctl to xfs
Message-ID: <20221121211547.GL3600936@dread.disaster.area>
References: <20221118211408.72796-1-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118211408.72796-1-catherine.hoang@oracle.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 18, 2022 at 01:14:06PM -0800, Catherine Hoang wrote:
> Hi all,
> 
> This patch aims to hoist the ext4 get/set ioctls to the VFS so we have a
> common interface for tools such as coreutils. The second patch adds support
> for FS_IOC_GETFSUUID in xfs (with FS_IOC_SETFSUUID planned for future patches).

FWIW, the next version needs to be cc'd to
linux-fsdevel@vger.kernel.org because we're talking about lifting an
ioctl to the VFS layer...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
