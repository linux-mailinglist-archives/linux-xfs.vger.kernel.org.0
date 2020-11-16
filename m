Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508E22B5398
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Nov 2020 22:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgKPVQS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Nov 2020 16:16:18 -0500
Received: from sandeen.net ([63.231.237.45]:56974 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgKPVQS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Nov 2020 16:16:18 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 41D062A96;
        Mon, 16 Nov 2020 15:15:54 -0600 (CST)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
 <160375537615.881414.8162037930017365466.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 20/26] xfs_db: report bigtime format timestamps
Message-ID: <c0460761-65ba-0dbf-4b61-f262e19a16bb@sandeen.net>
Date:   Mon, 16 Nov 2020 15:16:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <160375537615.881414.8162037930017365466.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/26/20 6:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Report the large format timestamps.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

hch had some concerns about this, but we didn't seem to reach a
resolution... I'd like to get the bigtime stuff done this release
and not navel-gaze too much about weird abis etc, so I'm inclined
to just take this and we can fix it later in the release and/or
when somebody hits that BUG_ON...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

