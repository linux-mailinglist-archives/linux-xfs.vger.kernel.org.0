Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D0B254630
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Aug 2020 15:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgH0Nnz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Aug 2020 09:43:55 -0400
Received: from sandeen.net ([63.231.237.45]:56220 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgH0Nnv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Aug 2020 09:43:51 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B2D3F2ACC;
        Thu, 27 Aug 2020 08:43:20 -0500 (CDT)
Subject: Re: [PATCH V2] xfs: fix boundary test in xfs_attr_shortform_verify
To:     Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
 <20200827081239.GC7605@infradead.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2087b7d7-2210-17a1-3b92-12519d945866@sandeen.net>
Date:   Thu, 27 Aug 2020 08:43:32 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200827081239.GC7605@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/27/20 3:12 AM, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can you follow up with the struct definition fix ASAP?

Working on delegating that task, yes.

-Eric
