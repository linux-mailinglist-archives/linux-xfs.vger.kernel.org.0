Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936752B3B76
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Nov 2020 03:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgKPCbR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 15 Nov 2020 21:31:17 -0500
Received: from sandeen.net ([63.231.237.45]:59516 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgKPCbR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Nov 2020 21:31:17 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 94B7D7904;
        Sun, 15 Nov 2020 20:30:54 -0600 (CST)
Subject: Re: [PATCH 02/27] xfsprogs: remove unused IO_DEBUG functionality
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20201015072155.1631135-1-david@fromorbit.com>
 <20201015072155.1631135-3-david@fromorbit.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9a55fdaf-4b8a-d844-57d9-6123b1e2d011@sandeen.net>
Date:   Sun, 15 Nov 2020 20:31:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201015072155.1631135-3-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/15/20 2:21 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to the XFS_BUF_TRACING code, this is largely unused and not
> hugely helpfule for tracing buffer IO. Remove it to simplify the
> conversion process to the kernel buffer cache.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Fine by me, I can merge this ahead of other stuff so you don't
have to carry it along.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
