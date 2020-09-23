Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753B22764BE
	for <lists+linux-xfs@lfdr.de>; Thu, 24 Sep 2020 01:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIWXxJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Sep 2020 19:53:09 -0400
Received: from sandeen.net ([63.231.237.45]:59606 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgIWXxJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Sep 2020 19:53:09 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 750D02AEA;
        Wed, 23 Sep 2020 18:52:33 -0500 (CDT)
Subject: Re: [PATCH STABLE] xfs: trim IO to found COW exent limit
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
References: <e7fe7225-4f2b-d13e-bb4b-c7db68f63124@redhat.com>
 <34c164fb-d616-1467-c96a-77c99e436421@redhat.com>
 <20200923225939.GY7955@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <856a658e-6b8f-e8cd-eee0-c1878abf0d89@sandeen.net>
Date:   Wed, 23 Sep 2020 18:53:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200923225939.GY7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/23/20 5:59 PM, Darrick J. Wong wrote:
> On Wed, Sep 23, 2020 at 05:37:39PM -0500, Eric Sandeen wrote:
>> Here's a reproducer for the bug.
>>
>> Requires sufficient privs to mount a loopback fs.
> 
> Please turn this into an fstest case, but otherwise this looks
> reasonable.

yeah, will do.
