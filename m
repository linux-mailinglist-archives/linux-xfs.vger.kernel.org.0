Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3919D3151DD
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 15:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBIOmR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Feb 2021 09:42:17 -0500
Received: from sandeen.net ([63.231.237.45]:51634 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhBIOmR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 09:42:17 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 18C3F1911D;
        Tue,  9 Feb 2021 08:39:19 -0600 (CST)
Subject: Re: [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384955.3057868.8076509276356847362.stgit@magnolia>
 <20210209091534.GH1718132@infradead.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f52ff4e2-16c3-89dd-30aa-a29f56cd29d1@sandeen.net>
Date:   Tue, 9 Feb 2021 08:41:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209091534.GH1718132@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/9/21 3:15 AM, Christoph Hellwig wrote:
> On Mon, Feb 08, 2021 at 08:10:49PM -0800, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> Quietly set up the ability to tell xfs_repair to set NEEDSREPAIR at
>> program start and (presumably) clear it by the end of the run.  This
>> code isn't terribly useful to users; it's mainly here so that fstests
>> can exercise the functionality.
> 
> What does the quietly above mean?

I think it means "don't document it in the man page, this is a secret
for XFS developers and testers"

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
