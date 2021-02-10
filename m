Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F921317196
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Feb 2021 21:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbhBJUpF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Feb 2021 15:45:05 -0500
Received: from sandeen.net ([63.231.237.45]:46198 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233336AbhBJUo7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 15:44:59 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B17EE15D9D;
        Wed, 10 Feb 2021 14:44:17 -0600 (CST)
Subject: Re: [PATCH 08/10] xfs_repair: allow setting the needsrepair flag
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284384955.3057868.8076509276356847362.stgit@magnolia>
 <20210209091534.GH1718132@infradead.org>
 <f52ff4e2-16c3-89dd-30aa-a29f56cd29d1@sandeen.net>
 <20210209164713.GE7190@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d6db1430-82e7-5d01-6c9d-7cdedd4d1612@sandeen.net>
Date:   Wed, 10 Feb 2021 14:44:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209164713.GE7190@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/9/21 10:47 AM, Darrick J. Wong wrote:
> "We don't document this flag in the manual pages at all because repair
> clears needsrepair at exit, which means the knobs only exist for fstests
> to exercise the functionality."

I can add that and save you a re-send.

-Eric
