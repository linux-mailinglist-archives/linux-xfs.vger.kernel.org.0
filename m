Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2128931474E
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 05:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBIEGR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Feb 2021 23:06:17 -0500
Received: from sandeen.net ([63.231.237.45]:48680 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229824AbhBIEDS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:03:18 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 041AE5A0A5;
        Mon,  8 Feb 2021 22:00:01 -0600 (CST)
To:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210209021843.GP7193@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: fix rst syntax error in admin guide
Message-ID: <1dea20c1-f261-e74a-fd6a-7c51974b3142@sandeen.net>
Date:   Mon, 8 Feb 2021 22:02:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209021843.GP7193@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/8/21 8:18 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Tables are supposed to have a matching line of "===" to signal the end
> of a table.  The rst compiler gets grouchy if it encounters EOF instead,
> so fix this warning.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

<cuts and pastes the prior "============     ===========" next to the 
new one, yup pretty, pretty good>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  Documentation/admin-guide/xfs.rst |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index d2064a52811b..6178153d3320 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -536,3 +536,4 @@ The interesting knobs for XFS workqueues are as follows:
>    cpumask        CPUs upon which the threads are allowed to run.
>    nice           Relative priority of scheduling the threads.  These are the
>                   same nice levels that can be applied to userspace processes.
> +============     ===========
> 
