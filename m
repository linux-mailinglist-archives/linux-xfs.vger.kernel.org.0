Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B672B6D12
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Nov 2020 19:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgKQSSL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Nov 2020 13:18:11 -0500
Received: from sandeen.net ([63.231.237.45]:60730 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730914AbgKQSSK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Nov 2020 13:18:10 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 075192420;
        Tue, 17 Nov 2020 12:17:45 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375537615.881414.8162037930017365466.stgit@magnolia>
 <20201117174521.GY9695@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 20/26] xfs_db: report bigtime format timestamps
Message-ID: <ef478bc8-8542-131e-84f0-c68c7c57874c@sandeen.net>
Date:   Tue, 17 Nov 2020 12:18:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201117174521.GY9695@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/17/20 11:45 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Report the large format timestamps in a human-readable manner if it is
> possible to do so without loss of information.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: skip the build bug stuff and check directly for information loss in
> the time64_t -> time_t conversion

This looks reasonable to me.  Thanks for working this all out.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
