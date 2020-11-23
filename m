Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA0E2C14DF
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Nov 2020 20:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgKWTxO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 23 Nov 2020 14:53:14 -0500
Received: from sandeen.net ([63.231.237.45]:34874 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730872AbgKWTxO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Nov 2020 14:53:14 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 39D8FEDD;
        Mon, 23 Nov 2020 13:53:10 -0600 (CST)
Subject: Re: [PATCH 03/27] libxfs: get rid of b_bcount from xfs_buf
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-4-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a657dea1-8eaf-073f-dd7f-7b3ab2078fb4@sandeen.net>
Date:   Mon, 23 Nov 2020 13:53:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201015072155.1631135-4-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/15/20 2:21 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We no longer use it in the kernel - it has been replaced by b_length
> and it only exists in userspace because we haven't converted it
> over. Do that now before we introduce a heap of code that doesn't
> ever set it and so breaks all the progs code.
> 
> WHile we are doing this, kill the XFS_BUF_SIZE macro that has also
> been removed from the kernel, too.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Sorry, I should have picked this up earlier with the couple other "trivial"
patches in this series, will do so now.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

